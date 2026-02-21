SMODS.Joker {
  key = "lipstick_queen",
  config = {
    extra = {
      x_chips_per_kissed = 0.5,
      x_chips = 1
    }
  },
  rarity = 1,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_kissed = true,
  },

  loc_vars = function(self, info_queue, card)

    return {
      vars = {
        card.ability.extra.x_chips_per_kissed,
        card.ability.extra.x_chips
      }
    }
  end,

  calculate = function (self, card, context)
    -- --First scored face card gives Xchips for every Kissed card in deck
    if context.individual and not context.end_of_round and context.cardarea == G.play then
      
      -- Find the first scored face
      local first_face = nil
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i]:is_face() then
          if not first_face then
            first_face = context.scoring_hand[i];
            break
          end
        end
      end

      --Return Xchips when first face card is scored
      if context.other_card == first_face then
        return {
            x_chips = card.ability.extra.x_chips
        }
      end
    end
  end,


  update = function(self, card, dt)
    -- Update the X Chips this card gives by counting the amount of Kissed cards
    if G.playing_cards then
      local total = 0

      for _, card_in_deck in ipairs(G.playing_cards) do
        if card_in_deck.ability.dragqueen_kissed then
          total = total + 1
        end
      end
      card.ability.extra.x_chips = 1 + (total * DRAGQUEENMOD.to_number(card.ability.extra.x_chips_per_kissed))
    end
  end,
}
