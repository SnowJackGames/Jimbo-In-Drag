SMODS.Joker {
  key = "messy_queen",
  config = {
    extra = {
      x_mult = 3.5,
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
    requires_kissed = true,
    is_a_drag_queen = true,
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.x_mult
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      -- Find the number of kissed cards in hand
      local kissed_cards_in_hand = 0
      for _, played_card in ipairs(context.scoring_hand) do
        if played_card.ability.dragqueen_kissed == true then
          kissed_cards_in_hand = kissed_cards_in_hand + 1
        end
      end

      -- If there were 3 or more Kissed cards in played hand, gives XMult
      if kissed_cards_in_hand > 2 then
        return {
          x_mult = card.ability.extra.x_mult
        }
      end
    end
  end,
}