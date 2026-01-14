SMODS.Joker {
  key = "lipstick",
  config = {
    extra = {
      odds = 4,
      xdollars = 0.1,
      accessorize_count = 1,
      money_cap = 20
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
    requires_purses = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_accessorize_tooltip" }
    info_queue[#info_queue + 1] = G.P_CENTERS.c_sun
    local num, denom = SMODS.get_probability_vars(
      card, 1, card.ability.extra.odds)
    return { vars = { num, denom, card.ability.extra.xdollars, card.ability.extra.money_cap} }
  end,

  calculate = function(self, card, context)
    -- 1 in 4 chance for played cards with Purse suit to earn X0.1 money when scored
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("dragqueen_Purses") then
        if SMODS.pseudorandom_probability(card, "example_seed", 1, card.ability.extra.odds) then
          local multiplicand = card.ability.extra.xdollars
          local cap = card.ability.extra.money_cap
          local existing_money = DRAGQUEENMOD.to_big(G.GAME.dollars) + (DRAGQUEENMOD.to_big(G.GAME.dollar_buffer or 0))
          local to_earn = (existing_money * multiplicand)
          -- Minimum between (money in pool X xdollars) and the cap, default 20 dollars
          to_earn = DRAGQUEENMOD.to_big(math.min(to_earn, cap))
            return {
              dollars = to_earn
            }
        end
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize("dragqueen_purses", card.ability.extra.accessorize_count)
  end
}
