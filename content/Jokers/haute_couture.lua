-- Played cards with a non-Plain suit give Mult when scored

SMODS.Joker {
  key = "haute_couture",
  config = {
    extra = {
      s_mult = 6,
      accessorize_suit = "random",
      accessorize_count = 2
    }
  },
  rarity = 2,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true,
    requires_spectrum_or_suit = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { set = "Other", key = "dragqueen_plain_suits" }
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)

    return {
      vars = {
        card.ability.extra.s_mult,
        card.ability.extra.accessorize_count
      }
    }
  end,

  calculate = function(self, card, context)
    -- Played cards with a non-plain suit give mult when scored
    if context.individual and context.cardarea == G.play then
      if DRAGQUEENMOD.is_non_plain_suit(context.other_card) then
        return {
          mult = card.ability.extra.s_mult
        }
      end
    end
  end,


  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
