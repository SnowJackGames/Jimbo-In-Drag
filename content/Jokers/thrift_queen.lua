-- Thrift Queen: Shop prices are reduced by $[] for every [] Purse cards in deck, min 1 dollar

SMODS.Joker {
  key = "thrift_queen",
  config = {
    extra = {
      discount_per_purse = 0.25,
      discount = 0,
      minimum = 1,
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
    requires_jokers = true,
    is_a_drag_queen = true
  },

  loc_vars = function(self, info_queue, card)
    local total = 0

    if G.playing_cards then
      for _, card_in_deck in ipairs(G.playing_cards) do
        if card_in_deck:is_suit("dragqueen_Purses") then
          total = total + 1
        end
      end
    end

    return {
      vars = {
        card.ability.extra.discount_per_purse,
        total * DRAGQUEENMOD.to_number(card.ability.extra.discount_per_purse),
        card.ability.extra.minimum
      }
    }
  end,

  calculate = function (self, card, context)
    -- Using code from CardSleeves (plasma deck with plasma sleeve)
    if context.starting_shop or context.reroll_shop then
      ------------------------------
      -- Calc Thrift Queen discount
      ------------------------------

      -- Update discount based on amount of Purses in deck
      if G.playing_cards then
        local total = 0
        for _, card_in_deck in ipairs(G.playing_cards) do
          if card_in_deck:is_suit("dragqueen_Purses") then
            total = total + 1
          end
        end
        card.ability.extra.discount = (total * DRAGQUEENMOD.to_number(card.ability.extra.discount_per_purse))
      end

      ------------------------------
      -- Take control
      ------------------------------

      local hold = 0.6  -- how long to take to ease the costs, and how long to hold the player
      G.CONTROLLER.locks.shop_reroll = true  -- stop controller/mouse from doing anything
      if G.CONTROLLER:save_cardarea_focus("shop_jokers") then G.CONTROLLER.interrupt.focus = true end

      ------------------------------
      -- Apply discount to shop items
      ------------------------------

      G.E_MANAGER:add_event(Event{ delay = 0.1, blockable = true, trigger = "after", func = function()
        -- We find the shop cardareas
        local cardareas = {}
        for _, obj in pairs(G) do
          if type(obj) == "table" and obj["is"] and obj:is(CardArea) and obj.config and obj.config.type == "shop" then
            cardareas[#cardareas+1] = obj
          end
        end

        ------------------------------
        -- Calc new price with discount
        ------------------------------

        -- Determine discount for every item in shop cardarea
        for _, cardarea in pairs(cardareas) do
          for _, item_in_shop in pairs (cardarea.cards) do

            -- Manage discount for card added to shop
            local cost = DRAGQUEENMOD.to_number(item_in_shop.cost)
            local discount = DRAGQUEENMOD.to_number(card.ability.extra.discount)
            local minimum = DRAGQUEENMOD.to_number(card.ability.extra.minimum)

            if discount > 0 then
              -- Don't do anything if price is below $1
              if cost <= 1 then

              -- If cost is above 1
              elseif cost > 1 then
                local new_price = cost - discount

                -- min price
                if new_price <= minimum then
                  item_in_shop.cost = 1

                -- discount
                else
                  item_in_shop.cost = (cost - discount)
                end
              end
            end
          end
        end

        ------------------------------
        -- Sound / visual event
        ------------------------------

        G.E_MANAGER:add_event(Event{ func = function()
          local sound = "coin" .. tostring(math.random(7))
          play_sound(sound, 1.6, 1)
          SMODS.calculate_effect({
            message = DRAGQUEENMOD.easymisclocalize("dictionary", "k_dragqueen_thrift_queen_thrift"),
            sound = sound
          }, card)
          return true
          end
        })

        ------------------------------
        -- Return control
        ------------------------------

        G.E_MANAGER:add_event(Event{ trigger = "after", delay = hold, func = function()
          G.CONTROLLER.interrupt.focus = false
          G.CONTROLLER.locks.shop_reroll = false
          G.CONTROLLER:recall_cardarea_focus('shop_jokers')
          return true
          end
        })
        return true
        end
      })
    end
  end
}
