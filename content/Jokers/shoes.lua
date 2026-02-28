

SMODS.Joker {
  key = "shoes",
  config = {
    extra = {
      odds = 2,
      currentcost = 300,
      dollars = 8,
      accessorize_suit = "dragqueen_Pumps",
      accessorize_count = 2
    }
  },
  rarity = 3,
  pos = { x = 4, y = 0 },
  atlas = "Joker_Doodles",
  cost = 300,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true,
    requires_purses = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
    info_queue[#info_queue + 1] = G.P_CENTERS[DRAGQUEENMOD.suits_to_consumable[card.ability.extra.accessorize_suit]]

    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote)

    local num, denom = SMODS.get_probability_vars(
      card, 1, card.ability.extra.odds)
    return {
      vars = {
        card.ability.extra.dollars,
        num,
        denom,
        card.ability.extra.accessorize_count,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    -- When being purchased and is in shop, cost is reduced to existing_money (implemented in joker.toml)
    -- When scoring a pair of Pumps, earn 8 dollars, then 1 in 2 chance for scored cards to all gain a random edition
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.before and context.scoring_name == "Pair" then
        -- Figure out which cards in the pair are the same rank; can technically be more than two with certain mods, such as Ice Card Enhancement in the mod All in Jest
        local scoring_pump_card_index_to_rank = {}
        local pair_positions = {}
        local successive_same_rank_cards = 0

        -- Gets the rank of every scored Pump
        for index, scoringcard in ipairs(context.scoring_hand) do
          if scoringcard:is_suit("dragqueen_Pumps") then
            scoring_pump_card_index_to_rank[index] = scoringcard:get_id()
          end
        end

        -- For every scored Pump, determine if its rank exists in scoring_pump_card_index_to_rank at least once
        for index, rank in pairs(scoring_pump_card_index_to_rank) do
          successive_same_rank_cards = 0
          -- Find how many times its rank appears in scoring_pump_card_index_to_rank
          for _, recursed_rank in pairs(scoring_pump_card_index_to_rank) do
            if rank == recursed_rank then
              successive_same_rank_cards = successive_same_rank_cards + 1
            end
          end
          -- If the same appears 2 or more times, that's good enough to consider it a pair of Pumps
          if successive_same_rank_cards > 1 then
            table.insert(pair_positions, index)
          end
        end

        -- Now, pair_positions should have as values the index of every Pumps card that we are considering at least part of a pair
        -- If there's at minimum 2 Pumps cards that are considered part of a pair, that's good enough to activate Shoes' ability
        if #pair_positions > 1 then
            -- earn 8 dollars
          SMODS.calculate_effect({
            dollars = card.ability.extra.dollars,
          }, card)

          -- 1 in 2 chance for scored cards to all gain a random edition
          if SMODS.pseudorandom_probability(card, "shoes", 1, card.ability.extra.odds) then
            -- "Rule!" message
            SMODS.calculate_effect({
              message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_shoes_rule")
            }, card)

            -- Add Editions
            for _, scored_card in ipairs(context.scoring_hand) do
                if not scored_card.edition then
                  local randomedition = poll_edition("shoes", nil, nil, true)
                  local attribute_table = {
                    edition = randomedition
                  }
                  DRAGQUEENMOD.convert_cards_to(scored_card, attribute_table, false, true)
                end
            end
            return {}
          else
            -- probability fail
            return {
              message = {DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_shoes_suck")}
            }
          end
        end
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
