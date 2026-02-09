SMODS.Joker {
  key = "tipsy_queen",
  config = {
    extra = {
      x_mult = 2,
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
  perishable_compat = true,

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    return {
      vars = {
        type = "name_text",
        set = "Enhanced",
        key = 'm_mult',

        card.ability.extra.x_mult
      }
    }
  end,

  calculate = function (self, card, context)
    -- Glass cards score an additional x2 mult but are guaranteed to break

    -- Whenever a glass card breaks, its probability is set to 100%
                -- if scoring_hand[i].ability.name == 'Glass Card' then 
                --     scoring_hand[i].shattered = true
  end
}


local dragqueen_hook_get_chip_x_mult = Card.get_chip_x_mult
---@diagnostic disable-next-line: duplicate-set-field
function Card.get_chip_x_mult(self)
  local amt = dragqueen_hook_get_chip_x_mult(self)

  if SMODS.has_enhancement(self, "m_glass") then
    local _, joker = next(SMODS.find_card('j_dragqueen_tipsy_queen', false))

    if joker then
      -- When a glass card scores, score an additional x2 mult
      amt = amt + joker.ability.extra.x_mult
    end
  end

  return amt
end
