SMODS.Joker {
  key = "obsession",
  config = {
    extra = {
      x_mult = 1.5
    }
  },
  rarity = 2,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_kissed = true
  },

  loc_vars = function(self, info_queue, card)

    return {
      vars = {
        card.ability.extra.x_mult
      }
    }
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then

        -- If held_card is kissed, it returns xmult
        if context.other_card.ability.dragqueen_kissed == true then
          return {
            x_mult = card.ability.extra.x_mult
          }
        end
      end

  end
}