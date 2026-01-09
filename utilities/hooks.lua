---@diagnostic disable: duplicate-set-field

-- Hooking Balatro's Game:start_run()
local dragqueen_hook_start_run = Game.start_run

-- Hook that sets NonPlain to false at the start of a run
function Game:start_run(...)
  dragqueen_hook_start_run(self, ...)
  G.GAME.NonPlain = false
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