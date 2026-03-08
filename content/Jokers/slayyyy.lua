-- +$money * Ante if you win on first hand with no discards

SMODS.Joker {
  key = "slayyyy",
  config = {
    extra = {
      money = 5,
      slayed_this_round_with_no_discards = false,
    }
  },
  rarity = 2,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_slay" }

    return {
      vars = {
        card.ability.extra.money
      }
    }
  end,

  calc_dollar_bonus = function(self, card)
    -- payout if Slayed with no discards
    if card.ability.extra.slayed_this_round_with_no_discards then
      -- resets value for next round
      local to_earn = DRAGQUEENMOD.to_number(card.ability.extra.money) * G.GAME.round_resets.ante
      return to_earn
    end
  end,

  calculate = function (self, card, context)
    -- Reset at start of round
    if context.setting_blind then
      card.ability.extra.slayed_this_round_with_no_discards = false
    end

    -- Determine if should get reward
    if context.after then
      -- During first hand of round, before discards used
      if (G.GAME.current_round.hands_played == 0) and (G.GAME.current_round.discards_used == 0) then

        -- If you Slay, then you can get reward
        if DRAGQUEENMOD.final_scoring_step_slay() then
          card.ability.extra.slayed_this_round_with_no_discards = true
          SMODS.calculate_effect({
              message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_slay"),
              colour = G.C.DRAGQUEEN_KEYWORD
            }, card)
        end
      end
    end
  end
}
