SMODS.Joker {
  key = "lipstick",
  config = {
    extra = { odds = 4, xdollars = 0.2, accessorize_count = 1 }
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
    requires_purses = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_accessorize_tooltip" }
    info_queue[#info_queue + 1] = G.P_CENTERS.c_sun
    local num, denom = SMODS.get_probability_vars(
      card, 1, card.ability.extra.odds)
    return { vars = { num, denom, card.ability.extra.xdollars } }
  end,

  calculate = function(self, card, context)
    -- 1 in 4 chance for played cards with Purse suit to earn X0.2 money when scored
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("dragqueen_Purses") then
        if SMODS.pseudorandom_probability(card, 'example_seed', 1, card.ability.extra.odds) then
          return {
            message = "X" .. card.ability.extra.xdollars,
            colour = G.C.MONEY,
            dollars = G.GAME.dollars * card.ability.extra.xdollars
          }
        end
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize("dragqueen_purses", card.ability.extra.accessorize_count)
  end
}
