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
  -- We would have to either spoof the controller pressing and holding 'r' for about a second,
  -- or instead (as below) mostly copy the reset code,
  -- along with a few other mods' known patches
  -- if you know of a mod that interacts wonkily with this, let me (Kassandra, github KassLavender) know

  -- Below emulates Balatro's base code for `Controller:key_hold_update()`

  -- G.SETTINGS.current_setup = "New Run"
  -- G.GAME.viewed_back = nil
  -- G.run_setup_seed = G.GAME.seeded
  -- G.challenge_tab = G.GAME and G.GAME.challenge and G.GAME.challenge_tab or nil

  -- -- This is some Handy and Aikoyori's Schenanigans stuff from their patches of Balatro's `Controller:key_hold_update()`
  -- if AKYRS and next(SMODS.find_mod("aikoyorisshenanigans")) and next(SMODS.find_mod("Handy")) then
  --   if type(G.challenge_tab) == "string" and G.GAME and G.GAME.challenge then
  --     if get_challenge_int_from_id(G.GAME.challenge or '') then
  --       G.challenge_tab = G.CHALLENGES[get_challenge_int_from_id(G.GAME.challenge or '') or ''] or {name = 'ERROR'}
  --       G.challenge_tab = AKYRS.HC_CHALLENGES[AKYRS.get_hc_challenge_int_from_id(G.GAME.challenge or '') or ''] or {name = 'ERROR'}
  --     end
  --   end

  -- elseif next(SMODS.find_mod("Handy")) then
  --   if type(G.challenge_tab) == "string" and G.GAME and G.GAME.challenge then
  --       G.challenge_tab = G.CHALLENGES[get_challenge_int_from_id(G.GAME.challenge or '') or ''] or {name = 'ERROR'}
  --   end
  -- end

  -- -- Now resuming emulating Balatro's base code
  -- G.forced_seed, G.setup_seed = nil, nil
  -- if G.GAME.seeded then G.forced_seed = G.GAME.pseudorandom.seed end
  -- G.forced_stake = G.GAME.stake
  -- if G.STAGE == G.STAGES.RUN then G.FUNCS.start_setup_run() end
  -- G.forced_stake = nil
  -- G.challenge_tab = nil
  -- G.forced_seed = nil



print(SMODS.Keybinds)


G.CONTROLLER:key_hold_update("r", 2)





  print("MEOWWWWWW")
end