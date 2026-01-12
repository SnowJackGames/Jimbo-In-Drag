SMODS.Joker {
  key = "tights",
  config = {
    extra = { odds = 3, xchips = 1.5 , accessorize_count = 1}
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
    requires_pumps = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_accessorize_tooltip" }
    info_queue[#info_queue + 1] = G.P_CENTERS.c_sun
    local num, denom = SMODS.get_probability_vars(
      card, 1, card.ability.extra.odds)
    return { vars = { num, denom, card.ability.extra.xchips } }
  end,

  calculate = function(self, card, context)
    -- 1 in 3 chance for played cards with Pump suit to give X1.5 Chips when scored
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("Pumps") and SMODS.pseudorandom_probability(card, 'example_seed', 1, card.ability.extra.odds) then
        return {
          xchips = card.ability.extra.xchips
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize("dragqueen_pumps", card.ability.extra.accessorize_count)
  end
}
