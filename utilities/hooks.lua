---@diagnostic disable: duplicate-set-field, lowercase-global



------------------------------
-- Colors, UI, badges
------------------------------



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



-- Hooking Balatro's create_UIBox_detailed_tooltip
local dragqueen_hook_create_UIBox_detailed_tooltip = create_UIBox_detailed_tooltip

-- Lets UI key "detailed_tooltip" create a set of tooltips instead of just one
function create_UIBox_detailed_tooltip(_center_or_set_of_centers, badges, ...)
  local is_a_set_of_centers = true
  local passed_badges = badges or nil

  -- We have to determine if we're being passed a _center or a set of _centers
  for _, item in pairs(_center_or_set_of_centers) do
    if type(item) ~= "table" then
      is_a_set_of_centers = false
    end
  end

  -- If it's a tooltip_from_function we treat it differently
  if _center_or_set_of_centers.tooltip_from_function ~= nil then is_a_set_of_centers = false end

  
  if is_a_set_of_centers then
    local UI_box_set = {}
    local nodes_set = {}

    -- Get the localized UI for each item
    for _, individual_center in pairs(_center_or_set_of_centers) do
      passed_badges = individual_center.badges or nil
      local UI_box = create_UIBox_detailed_tooltip(individual_center, passed_badges, ...)

      UI_box_set[#UI_box_set+1] = UI_box
    end

    for _, UI_box in ipairs(UI_box_set) do
      local tooltip_node_instance = UI_box.nodes[1]
      local arranged_node = {
          n = G.UIT.C,
          config = {
            align = "tl",
          },
          nodes = {tooltip_node_instance}
      }
      nodes_set[#nodes_set+1] = arranged_node
    end
    
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        colour = G.C.CLEAR
      },
      nodes = {
        { n = G.UIT.C,
          config = {
            padding = 0.05
          },
          nodes = nodes_set
        }
      }
    }

-- Regular single detailed_tooltip item
  else
    local _center = _center_or_set_of_centers
    local UI_box = nil

    -- Alternative way to build tooltip from function
    if _center.tooltip_from_function ~= nil then
      if (_center.set ~= nil) or (_center.key ~= nil) then
        error("_center passed through dragqueen_hook_create_UIBox_detailed_tooltip hooking create_UIBox_detailed_tooltip can't process both _center.tooltip_from_function along with _center.set or _center.key at same time")
      else
        UI_box = _center.tooltip_from_function
      end

    -- Standard way to build tooltip
    else
      UI_box = dragqueen_hook_create_UIBox_detailed_tooltip(_center, passed_badges, ...)
    end

    return UI_box
  end
end



-- Hooking SMODS's .create_mod_badges()
local dragqueen_hook_suit_badge = SMODS.create_mod_badges

-- Puts a badge under a suited card indicating if it is a Light Suit, a Dark Suit, or both
function SMODS.create_mod_badges(obj, badges, ...)
  dragqueen_hook_suit_badge(obj, badges, ...)
  DRAGQUEENMOD.card_suit_badge(obj, badges)
end



------------------------------
-- Game events
------------------------------



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



-- Hooking Balatro's set_language()
local dragqueen_hook_set_language = Game.set_language

-- Hook that sorts the dictionary / things that reference localization in case language changes
function Game:set_language(...)
  dragqueen_hook_set_language(self, ...)
  DRAGQUEENMOD.locally_sort_built_dictionary()
  DRAGQUEENMOD.build_dictionary()
  DRAGQUEENMOD.locally_sort_built_dictionary()
end

------------------------------
-- Last-second code
------------------------------
-- Code that we want to run after all the mods are injected, but before the game hits the start menu
-- This helps reduce the need to delay our mod's priority to be after mods we want to consider but aren't dependencies



-- Code to be hooked into the end of Game:splash_screen
function DRAGQUEENMOD.last_second_code()
  if DRAGQUEENMOD.load_cross_mod_ours_to_theirs then
    DRAGQUEENMOD.cross_mod_ours_to_theirs()
  end
  DRAGQUEENMOD.build_custom_structure_dictionary_tooltips()
  DRAGQUEENMOD.build_dictionary()
  DRAGQUEENMOD.locally_sort_built_dictionary()
end



-- Hooking Balatro's Game:splash_screen()
-- runs after all mods are initialized
local dragqueen_hook_splash_screen = Game.splash_screen

function Game:splash_screen(...)
  dragqueen_hook_splash_screen(self, ...)
  DRAGQUEENMOD.last_second_code()
end
