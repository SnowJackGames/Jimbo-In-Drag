---@diagnostic disable: duplicate-set-field, lowercase-global

-- Hooking Balatro's Game:start_run()
local dragqueen_hook_start_run = Game.start_run

-- Hook that sets NonPlain to false at the start of a run
function Game:start_run(...)
  dragqueen_hook_start_run(self, ...)
  G.GAME.NonPlain = DRAGQUEENMOD.non_plain_in_pool()
end


-- Hooking Balatro's G.FUNCS.evaluate_play()
DRAGQUEENMOD.dragqueen_hook_evaluate_play = G.FUNCS.evaluate_play

-- Hook that enables non_plain functionality when a spectrum is played
G.FUNCS.evaluate_play = function(e)
  local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)

  if G.GAME.NonPlain == false or nil then
    if string.find(text, "Spectrum") or string.find(text, "Specflush") then
      DRAGQUEENMOD.enable_non_plains()
    end
  end

  DRAGQUEENMOD.dragqueen_hook_evaluate_play(e)
end



-- Hooking SMODS's .create_mod_badges()
local dragqueen_hook_suit_badge = SMODS.create_mod_badges

-- Puts a badge under a suited card indicating if it is a Light Suit, a Dark Suit, or both
function SMODS.create_mod_badges(obj, badges, ...)
  dragqueen_hook_suit_badge(obj, badges, ...)
  DRAGQUEENMOD.card_suit_badge(obj, badges)
end

-- Hooking Balatro's loc_colour()
local dragqueen_hook_loc_colour = loc_colour

-- Adds our colors from global scope into G.ARGS.LOC_COLOURS
function loc_colour(_c, _default, ...)
  if not G.ARGS.LOC_COLOURS then
	  dragqueen_hook_loc_colour()
	end
  DRAGQUEENMOD.color_register_into_LOC_COLOURS()
  return dragqueen_hook_loc_colour(_c, _default, ...)
end



-- Code to be hooked into the end of Game:splash_screen
function DRAGQUEENMOD.last_second_code()
  if DRAGQUEENMOD.load_cross_mod_ours_to_theirs then
    DRAGQUEENMOD.cross_mod_ours_to_theirs()
  end
end


-- Hooking Balatro's Game:splash_screen()
-- runs after all mods are initialized
local dragqueen_hook_splash_screen = Game.splash_screen

function Game:splash_screen(...)
  dragqueen_hook_splash_screen(self, ...)
  DRAGQUEENMOD.last_second_code()
end