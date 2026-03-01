-- Straight Up [Paula Abdul]: If hand contains a Straight, gain either a +1 hand or +1 discard

SMODS.Joker {
  key = "straight_up",
  config = {
    extra = {
      hands_given = 1,
      discards_given = 1,
      hand_size = -1,
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
    requires_jokers = true
  },

  loc_vars = function(self, info_queue, card)
    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote, true)

    local key = self.key
    if card.ability.eternal == false then
      key = key .. "_no_eternal"
    end

    return {
      key = key,
      vars = {
        card.ability.extra.hands_given,
        card.ability.extra.discards_given,
        card.ability.extra.hand_size,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    if context.after and context.main_eval then
      if next(context.poker_hands["Straight"]) then
        -- Gives a hand and a discard
        ease_hands_played(card.ability.extra.hands_given)
        ease_discard(card.ability.extra.discards_given)
      end
    end
  end,

  -- Always comes with an eternal sticker
  set_ability = function(self, card, initial, delay_sprites)
    card:add_sticker("eternal", true)
  end,

  -- Removes a hand size
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.hand_size)
  end,

  -- Adds back the hand size
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.hand_size)
  end,
}