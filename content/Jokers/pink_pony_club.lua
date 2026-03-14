-- Pink Pony Club: Every played card permanently gets X0.05 mult when scored if played hand contains a Spectrum
-- Accessorize random 2

SMODS.Joker {
  key = "pink_pony_club",
  config = {
    extra = {
      perma_x_mult = 0.05,
      accessorize_suit = "random",
      accessorize_count = 2
    }
  },
  rarity = 3,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 15,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true,
    requires_spectrum_or_suit = true,
    is_a_drag_queen = true,
    is_a_popstar = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)

    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote, true)

    return {
      vars = {
        card.ability.extra.perma_x_mult,
        card.ability.extra.accessorize_count,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    -- When a card is scored
    if context.individual and context.cardarea == G.play then
      if DRAGQUEENMOD.contains_hand(context.poker_hands, "Spectrum") then
        -- Increase played card's x_mult_gain
        context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 0
        context.other_card.ability.perma_x_mult = DRAGQUEENMOD.to_number(context.other_card.ability.perma_x_mult) + DRAGQUEENMOD.to_number(card.ability.extra.perma_x_mult)

        -- Return "Upgrade!" message 
        return {
          extra = {
            message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_upgrade_ex"),
            colour = G.C.MULT,
          },
          card = card
        }
      end
    end
  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}