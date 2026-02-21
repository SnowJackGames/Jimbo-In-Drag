SMODS.Joker {
  key = "book_signing",
  config = {
    extra = {
      money = 4
    }
  },
  rarity = 1,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,

  loc_vars = function(self, info_queue, card)

    return {
      vars = {
        card.ability.extra.money
      }
    }
  end,

  calculate = function (self, card, context)
    -- --First drawn card is kissed
    if context.first_hand_drawn then
      if G.hand.cards[1] ~= nil then
        DRAGQUEENMOD.kiss_card(G.hand.cards[1])
      end
    end
  end,

  -- Gives the money in the cash out screen
  calc_dollar_bonus = function(self, card)
    return card.ability.extra.money
  end
}
