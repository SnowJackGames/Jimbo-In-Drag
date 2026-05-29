-- If you would die, instead restarts run with a negative Bernkastel

SMODS.Joker {
  key = "bernkastel_witch_of_miracles",
  config = {
    extra = {
      accessorize_suit = "Spades",
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
        card.ability.extra.accessorize_count,
        quote
      }
    }
  end,

  calculate = function(self, card, context)
    -- restart game
    if context.game_over then
      DRAGQUEENMOD.bernkastel_reset()
      context.game_over = false
    end
  end,

  -- Accessorize
  add_to_deck = function(self, card, from_debuff)
    DRAGQUEENMOD.accessorize(card.ability.extra.accessorize_suit, card.ability.extra.accessorize_count)
  end
}


function DRAGQUEENMOD.bernkastel_reset()
  -- We want to emulate what happens when a round is suddenly reset (like when you pressed and hold "r" on a keyboard)
  -- but the "restart" event is embeded within Balatro's code for detecting "pressing and holding 'r'"
  -- in `Controller:key_hold_update()` in `engine/controller.lua`
  -- Some other mods also embed Lovely patches within this function
  -- THUSLY:
  -- In order for us to emulate Bernkastel resetting the game,
  -- We either need to do our own implementation of the `Controller:key_hold_update()` stuff,
  -- Or (as below) we just spoof the controller pressing and holding 'r' for about a second
  -- local old_hold_value = G.CONTROLLER.held_key_times.r
  -- G.CONTROLLER.held_key_times.r = 999
  -- G.CONTROLLER:key_hold_update("r", 0)
  -- G.CONTROLLER.held_key_times.r = old_hold_value
  DRAGQUEENMOD.start_with_bernkastel = true

  Handy.misc_controls.restart_fun()
  
end