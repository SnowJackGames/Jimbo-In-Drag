-- Gives X$Money at end of Blind for every Purse card in deck

SMODS.Joker {
  key = "big_bag",
  config = {
    extra = {
      xdollars = 0.05,
      accessorize_suit = "dragqueen_Purses",
      accessorize_count = 1
    }
  },
  rarity = 3,
  pos = { x = 2, y = 0 },
  soul_pos = { x = 3, y = 0 },
  atlas = "Joker_Doodles",
  cost = 15,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  dragqueen = {
    requires_jokers = true
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
    info_queue[#info_queue + 1] = G.P_CENTERS[DRAGQUEENMOD.suits_to_consumable[card.ability.extra.accessorize_suit]]

    return {
      vars = {
        card.ability.extra.xdollars,
        card.ability.extra.accessorize_count
      }
    }
  end,

  -- Gives the money in the cash out screen
  calc_dollar_bonus = function(self, card)
    local multiplicand = card.ability.extra.xdollars
    local existing_money = DRAGQUEENMOD.to_big(G.GAME.dollars) + (DRAGQUEENMOD.to_big(G.GAME.dollar_buffer or 0))
    local to_earn = DRAGQUEENMOD.to_big(existing_money * multiplicand)

    return to_earn
  end,

  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}
