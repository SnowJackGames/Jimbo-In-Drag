local function turn_into_apostle_of_pumps(card)
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.15, func = function()
    play_sound("tarot1")
    card:juice_up(0.3, 0.5)
    return true
  end })
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.3, func = function()
    card:flip()
    play_sound("card1", 0.85)
    card:juice_up(0.3, 0.3)
    return true
  end })
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.15, func = function()
    assert(SMODS.change_base(card, "dragqueen_Pumps", "paperback_Apostle"))
    card.ability.dragqueen_kissed = true
    return true
  end })
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.1, func = function()
    card:flip()
    play_sound("tarot2", 0.85, 0.6)
    card:juice_up(0.3, 0.3)
    return true
  end })
end


local function turn_into_debuff(card)
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.1, func = function()
    play_sound("cancel")
    card.ability.dragqueen_debuffed = true
    card:juice_up(0.3, 0.5)
    return true
  end })
end



SMODS.Joker {
  key = "snow_whites_apple",
  config = {
    extra = {
      x_mult_per_debuffed = 0.1,
      x_mult = 1,
    }
  },
  rarity = 3,
  pos = { x = 0, y = 1 },
  soul_pos = { x = 2, y = 1 },
  second_soul_pos = { x = 1, y = 1 },
  atlas = "Joker_Doodles",
  cost = 12,
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
    local current_x_mult = card.ability.extra.x_mult
    return {
      vars = {
        card.ability.extra.x_mult_per_debuffed,
        current_x_mult
      }
    }
  end,

  calculate = function (self, card, context)
    -- If played card is a high card, convert a random card held in hand into a kissed Apostle of Pumps
    -- if able, then disable another random card held in hand if able
    if context.after then
      if context.scoring_name == "High Card" then
        local number_of_cards_in_hand = #G.hand.cards

        -- If there's only one card in hand, turn it into a Kissed Apostle of Pumps
        if number_of_cards_in_hand == 1 then
          turn_into_apostle_of_pumps(G.hand.cards[1])

        -- If there are two or more cards in hand, turn one into a Kissed Apostle of Pumps,
        -- and then permanently disable another
        elseif number_of_cards_in_hand > 1 then

          local first_random_card = math.random(number_of_cards_in_hand)
          local second_random_card = first_random_card

          -- make sure the two random cards are different
          while second_random_card == first_random_card do
            second_random_card = math.random(number_of_cards_in_hand)
          end

          -- Modify the first random card
          turn_into_apostle_of_pumps(G.hand.cards[first_random_card])

          -- disable the second random card
          turn_into_debuff(G.hand.cards[second_random_card])

          return {
            message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_snow_whites_apple")
          }

        end
      end
    end

    -- Played Kissed Apostles score X0.5 Mult for each debuffed card in hand
    if context.individual and context.cardarea == G.play then
      if DRAGQUEENMOD.is_rank(context.other_card, "paperback_Apostle") then
        if context.other_card.ability.dragqueen_kissed == true then
          return {
            x_mult = card.ability.extra.x_mult
          }
        else
        end
      end
    end
  end,

  update = function(self, card, dt)
    -- Update the X mult this card gives by counting the amount of debuffed cards
    -- From Paperback's Jester of Nihil
    if G.playing_cards then
      local total = 0

      for _, v in ipairs(G.playing_cards) do
        if v.debuff then
          total = total + 1
        end
      end
      card.ability.extra.x_mult = 1 + (total * DRAGQUEENMOD.to_number(card.ability.extra.x_mult_per_debuffed))
    end
  end,
}
