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
  local is_a_set_of_centers = false

  -- We have to determine if we're being passed a _center or a set of _centers
  for _, item in pairs(_center_or_set_of_centers) do
    if type(item) == "table" then
      _center_or_set_of_centers = true
    end
  end

  if is_a_set_of_centers then
    local full_UI_table = {
        main = {},
        info = {},
        type = {},
        name = "done",
        badges = badges or {}
    }
    local desc_set = {}
    local nodes_set = {}

    -- Get the localized UI for each item
    for _, individual_center in pairs(_center_or_set_of_centers) do
      local desc = generate_card_ui(individual_center, full_UI_table, nil, individual_center.set, nil)
      table.insert(desc_set, desc)
    end

    for _, tooltip in ipairs(desc_set) do
      local tooltip_node_instance = {
        n = G.UIT.R,
        config = {
          align = "cm",
          colour = lighten(G.C.JOKER_GREY, 0.5),
          r = 0.1,
          padding = 0.05,
          emboss = 0.05
        },
        nodes = {
          info_tip_from_rows(tooltip.info[1], tooltip.info[1].name),
        }
      }
      table.insert(nodes_set, tooltip_node_instance)
    end
    
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        colour = G.C.CLEAR
      },
      nodes = {
        { n = G.UIT.R,
          config = {
            colour = G.C.CLEAR
          },
          nodes = nodes_set
        }
      }
    }

  -- Regular single detailed_tooltip item
    else
      local _center = _center_or_set_of_centers
      return dragqueen_hook_create_UIBox_detailed_tooltip(_center, ...)
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

-- Hook that sorts the dictionary in case language changes
function Game:set_language(...)
  dragqueen_hook_set_language(self, ...)
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
