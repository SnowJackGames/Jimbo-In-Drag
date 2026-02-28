
-- Joy Ride [Kesha]
-- Last played card gives
-- "Joyride" when scored, where
-- Joyride starts at 1X
-- ---
-- During each first hand of a round,
-- If you Slay, "Joyride" gains
-- X[0.2 x Ante] Mult
-- Otherwise, it resets

SMODS.Joker {
  key = "joyride",
  config = {
    extra = {
      current_joyride = 1,
      joyride_per_slay = 0.2,
      joyride_base = 1
    }
  },
  rarity = 3,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 9,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_slay" }

    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote)

    return {
      vars = {
        card.ability.extra.joyride_base,
        card.ability.extra.joyride_per_slay,
        card.ability.extra.current_joyride,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    if context.after and not context.blueprint then
      -- During first hand of round
      if G.GAME.current_round.hands_played == 0 then

        -- if slay, then increase
        if DRAGQUEENMOD.final_scoring_step_slay() then
          card.ability.extra.current_joyride = card.ability.extra.current_joyride + (card.ability.extra.joyride_per_slay * G.GAME.round_resets.ante)
          return {
            message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_joyride")
          }

        -- Otherwise, reset
        else
          card.ability.extra.current_joyride = card.ability.extra.joyride_base
        end
      end
    end

    -- Last played scored card scores XJoyride Mult
    if context.individual and context.cardarea == G.play then
      if context.other_card == context.scoring_hand[#context.scoring_hand] then
        return {
          x_mult = card.ability.extra.current_joyride
        }
      end
    end
  end
}