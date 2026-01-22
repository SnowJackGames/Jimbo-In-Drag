SMODS.Joker {
  key = "vain_joker",
  effect = "Suit Mult",
  config = {
    extra = {
      s_mult = 5,
      suit = "dragqueen_pumps",
      accessorize_count = 2
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
    requires_pumps = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_accessorize_tooltip" }
    info_queue[#info_queue + 1] = G.P_CENTERS.c_sun
    return {
      vars = {
        card.ability.extra.s_mult,
        card.ability.extra.accessorize_count
      }
    }
  end,
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize("dragqueen_Pumps", card.ability.extra.accessorize_count)
  end
}
