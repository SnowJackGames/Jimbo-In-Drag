-- When a Boss or Showdown Blind is selected, destroy a random Joker
-- When a Joker is destroyed, earn X2 Money and gain X1.5 Chips
-- Always Eternal

SMODS.Joker {
  key = "beatrice_eternal_golden_witch",
  config = {
    extra = {
      x_money = 2,
      x_chips_gain = 1,
      x_chips = 1,
      accessorize_suit = "Diamonds",
      accessorize_count = 2,
    }
  },
  rarity = 3,
  pos = { x = 0, y = 0 },
  atlas = "placeholder",
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
    local quotelocation = DRAGQUEENMOD.easydescriptionslocalize(self.set, self.key)
    local quote = DRAGQUEENMOD.get_quote(quotelocation.quote)

    return {
      vars = {
        card.ability.extra.x_chips_gain,
        card.ability.extra.x_money,
        card.ability.extra.x_chips,
        card.ability.extra.accessorize_count,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    ------------------------------
    -- X_chip gain
    ------------------------------

    -- When a joker is destroyed, gains x_chips
    if context.joker_type_destroyed and not context.blueprint then
      card:juice_up(0.3, 0.5)
      card.ability.extra.x_chips = DRAGQUEENMOD.to_number(card.ability.extra.x_chips) + DRAGQUEENMOD.to_number(card.ability.extra.x_chips_gain)

      local chessquotelocation = DRAGQUEENMOD.easydescriptionslocalize("Other", "dragqueen_beato_chess")
      local chessquote = DRAGQUEENMOD.get_quote(chessquotelocation.quote, true)
      return {
        message = chessquote,
        colour = G.C.RED
      }
    end

    ------------------------------
    -- Destroy random Joker
    ------------------------------

    -- At start of boss / showdown blind, destroys a random joker
    if context.setting_blind and not context.blueprint and context.blind.boss then
      -- Destruction code similar to "Madness"
      -- First find jokers that *could* be destroyed
      local destructable_jokers = {}
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
          destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i]
        end
      end

      -- Select a joker to kill, just like the Witch's Epitath
      local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed("Roulette")) or nil

      if joker_to_destroy then
        joker_to_destroy.getting_sliced = true
        G.E_MANAGER:add_event(Event { func = function()
          joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
          return true
        end })

        -- Gives money
        local multiplicand = card.ability.extra.x_money
        local existing_money = DRAGQUEENMOD.to_big(G.GAME.dollars) + (DRAGQUEENMOD.to_big(G.GAME.dollar_buffer or 0))
        local to_earn = DRAGQUEENMOD.to_big(existing_money * multiplicand)
        SMODS.calculate_effect({
          dollars = to_earn
        }, card)
      end
    end

    ------------------------------
    -- Main Scoring
    ------------------------------

    -- When scored, gives x_chips
    if context.joker_main then
      return {
        x_chips = card.ability.extra.x_chips
      }
    end
  end,

  -- Always comes with an eternal and rental sticker
  set_ability = function(self, card, initial, delay_sprites)
    card:add_sticker("eternal", true)
    card:add_sticker("rental", true)
    if DRAGQUEENMOD.config.beatrice_sounds then
      G.E_MANAGER:add_event(Event { trigger = "after", delay = 0.15, func = function()
        card:juice_up(0.3, 0.5)
        play_sound("dragqueen_laugh", 1,0.4)
        return true
      end })
    end
  end
}