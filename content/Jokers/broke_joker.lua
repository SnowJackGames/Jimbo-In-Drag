SMODS.Joker {
  key = "broke_joker",
  effect = "Suit Mult",
  config = {
    extra = {
      s_mult = 7,
      suit = "dragqueen_purses"
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
    return {
      vars = {
        card.ability.extra.s_mult
      }
    }
  end
}
