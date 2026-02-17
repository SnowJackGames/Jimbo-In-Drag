SMODS.Joker {
  key = "fishnets",
  config = {
    extra = {
      x_chips = 1.5,
      accessorize_suit = "dragqueen_Pumps",
      accessorize_count = 1
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
    requires_pumps = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
    info_queue[#info_queue + 1] = G.P_CENTERS[DRAGQUEENMOD.suits_to_consumable[card.ability.extra.accessorize_suit]]

    return {
      vars = {
        card.ability.extra.x_chips,
        card.ability.extra.accessorize_count
      }
    }
  end,

  -- Each card with Pump suit held in hand gives xchips
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then

        -- If held_card is a pump, it returns xchips
        if context.other_card:is_suit("dragqueen_Pumps") or SMODS.has_any_suit(context.other_card) then
          return {
            x_chips = card.ability.extra.x_chips
          }
        end
      end

  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}