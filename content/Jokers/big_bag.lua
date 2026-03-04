-- Gives X$Money at end of Blind for every Purse card in deck

SMODS.Joker {
  key = "big_bag",
  config = {
    extra = {
      xdollars_per_purse = 0.05,
      xdollars = 0,
      accessorize_suit = "dragqueen_Purses",
      accessorize_count = 1
    }
  },
  rarity = 3,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 15,
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
        card.ability.extra.xdollars_per_purse,
        total,
        card.ability.extra.accessorize_count
      }
    }
  end,

  -- Gives the money in the cash out screen
  calc_dollar_bonus = function(self, card)

    -- Calc X Money based on purses in deck
    if G.playing_cards then
      local total = 0

      for _, card_in_deck in ipairs(G.playing_cards) do
        if card_in_deck:is_suit("dragqueen_Purses") then
          total = total + 1
        end
      end
      card.ability.extra.xdollars = (total * DRAGQUEENMOD.to_number(card.ability.extra.xdollars_per_purse))
    end

    -- Calc actual earnings based on XMoney
    local multiplicand = card.ability.extra.xdollars
    local existing_money = DRAGQUEENMOD.to_big(G.GAME.dollars) + (DRAGQUEENMOD.to_big(G.GAME.dollar_buffer or 0))
    local to_earn = DRAGQUEENMOD.to_big(existing_money * multiplicand)

    return to_earn
  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
