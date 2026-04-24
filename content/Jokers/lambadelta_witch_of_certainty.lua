-- All probabilities are made certain
-- X 0.75 Mult

SMODS.Joker {
  key = "lambadelta_witch_of_certainty",
  config = {
    extra = {
      x_mult = 0.75,
      accessorize_suit = "Hearts",
      accessorize_count = 2,
    }
  },
  rarity = 1,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true,
    is_a_drag_queen = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
    info_queue[#info_queue + 1] = G.P_CENTERS[DRAGQUEENMOD.suits_to_consumable[card.ability.extra.accessorize_suit]]

    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote)

    return {
      vars = {
        card.ability.extra.x_mult,
        card.ability.extra.accessorize_count,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    -- All probabilities are made certain. Note that if multiple jokers use `context.fix_probability` that
    -- it will apply left to right along the jokers
    if context.fix_probability then
      return {
        numerator = DRAGQUEENMOD.to_number(context.denominator)
      }
    end

    -- returns a smaller amount of x_mult
    if context.joker_main then
      return {
        x_mult = card.ability.extra.x_mult,
        sound = "dragqueen_laugh",
        volume = 0.4
      }
    end
  end,

  -- Accessorize
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
