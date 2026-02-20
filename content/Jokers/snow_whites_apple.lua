SMODS.Joker {
  key = "snow_whites_apple",
  config = {
    extra = {
      x_mult = 0.5,
      base_x_mult = 1,
    }
  },
  rarity = 2,
  pos = { x = 0, y = 1 },
  soul_pos = { x = 2, y = 1 },
  second_soul_pos = { x = 1, y = 1 },
  atlas = "Joker_Doodles",
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_purses = true,
    requires_cross_mods = true
  },

  loc_vars = function(self, info_queue, card)
    local current_x_mult = card.ability.extra.base_x_mult
    return {
      vars = {
        card.ability.extra.x_mult,
        current_x_mult
      }
    }
  end,

  calculate = function (self, card, context)
    
  end
}
