-- "Filth is politics"... unscored cards in hand gain chips
-- Based on Divine
-- If you have Uniks installed, also accessorizes Crosses 1 (its a pink suit)


SMODS.Joker {
  key = "pink_flamingos",
  config = {
    extra = {
      perma_chips = 15,
      accessorize_suit = "unik_Crosses",
      accessorize_count = 1,
    }
  },
  rarity = 2,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 6,
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

    -- If Uniks is installed, we use the alternative text entry
    if next(SMODS.find_mod("unik")) and DRAGQUEENMOD.config.cross_mod_enabled then
      return {
        key = self.key .. "_uniks",
        vars = {
          card.ability.extra.perma_chips,
          card.ability.extra.accessorize_count,
          quote
        }
      }
    else
      return {
        vars = {
          card.ability.extra.perma_chips,
          quote
        }
      }
    end
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == "unscored" then
      -- if card is not scoring, give it chips
      context.other_card.ability.perma_bonus = DRAGQUEENMOD.to_big(context.other_card.ability.perma_bonus) or 0
      context.other_card.ability.perma_bonus = DRAGQUEENMOD.to_big(context.other_card.ability.perma_bonus) + DRAGQUEENMOD.to_big(card.ability.extra.perma_chips)
      return {
        message = localize("k_dragqueen_divine_chips"), colour = G.C.CHIPS
      }
    end
  end,

  -- Accessorize if Uniks installed
  add_to_deck = function(self, card, from_debuff)
    if next(SMODS.find_mod("unik")) and DRAGQUEENMOD.config.cross_mod_enabled then
      DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
    end
  end
}
