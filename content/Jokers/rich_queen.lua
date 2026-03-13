-- Every Joker gains $[] in sell value for every [] Purse cards in deck at end of round

SMODS.Joker {
  key = "rich_queen",
  config = {
    extra = {
      bonus_sale_value_per_purse = 0.20,
      accessorize_suit = "dragqueen_Purses",
      accessorize_count = 1,
      sell_value_increase = 0
    }
  },
  rarity = 2,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
    info_queue[#info_queue + 1] = G.P_CENTERS[DRAGQUEENMOD.suits_to_consumable[card.ability.extra.accessorize_suit]]

    local total = 0

    if G.playing_cards then
      for _, card_in_deck in ipairs(G.playing_cards) do
        if card_in_deck:is_suit("dragqueen_Purses") then
          total = total + 1
        end
      end
    end

    return {
      vars = {
        card.ability.extra.bonus_sale_value_per_purse,
        total * DRAGQUEENMOD.to_number(card.ability.extra.bonus_sale_value_per_purse),
        card.ability.extra.accessorize_count
      }
    }
  end,

  -- At end of round, increase each joker sell value based on number of purses
  calculate = function (self, card, context)
    if context.end_of_round and context.main_eval then
      ------------------------------
      -- Calc Rich Queen sell value increase
      ------------------------------

      -- Update sell value increase based on amount of Purses in deck
      if G.playing_cards then
        local total = 0
        for _, card_in_deck in ipairs(G.playing_cards) do
          if card_in_deck:is_suit("dragqueen_Purses") then
            total = total + 1
          end
        end
        card.ability.extra.sell_value_increase = (total * DRAGQUEENMOD.to_number(card.ability.extra.bonus_sale_value_per_purse))
      end

      ------------------------------
      -- Apply sell value increase
      ------------------------------

      -- For each joker, increase its sell value
      if G.jokers and G.jokers.cards then
        for _, individual_joker in ipairs(G.jokers.cards) do
          -- Increase sell 
          if individual_joker.set_cost then
            individual_joker.ability.extra_value = (DRAGQUEENMOD.to_number(individual_joker.ability.extra_value) or 0) + DRAGQUEENMOD.to_number(card.ability.extra.sell_value_increase)
            individual_joker.set_cost()
          end
          

          -- Value Up Message
          SMODS.calculate_effect({
            message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_val_up"),
            colour = G.C.Money
          }, individual_joker)
        end
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
