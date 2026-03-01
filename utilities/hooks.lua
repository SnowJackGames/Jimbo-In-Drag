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

    -- In en-us, G.P_CENTERS["c_sun"].name returns "The Sun",
    -- and G.localization.descriptions.Tarot.c_sun.name returns "The Sun"
    -- However, in other languages, the name entry in G.P_CENTERS stays the same, but the localization
    -- entry is different (ex. "Die Sonne" in Dutch)
    -- If a `_center` has a center and a key, and it corresponds to an item in G.P_CENTERS,
    -- *and* `_center` has a name_parsed table already,
    -- Then we need to override `_center.name` with the G.P_CENTERS one before passing through `create_UIBox_detailed_tooltip`
    -- Why? Because 

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



-- Hooking Balatro's generate_card_ui
local dragqueen_hook_generate_card_ui = generate_card_ui

-- If `_c` passed to generate_card_ui has a `.set`, `.key`, and `.name`
-- <br>and the key refers to a particular entry in `G.P_CENTERS`
-- <br>Let's make sure that .name is the same as `G.P_CENTERS[particular object].name`,
-- <br> in case that the `.name` value had been pulled from building an item through localization
-- <br>(which may be different if it's a language other than en-us.lua)
-- <br>this fixes a particular issue with our dictionary tooltip stuff when using different languages
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
  if _c.set and _c.key and _c.name then
    local item_location_values = {
      "P_CENTERS",
      "P_SEALS",
      "P_TAGS",
      "P_STAKES",
      "P_BLINDS",
      -- dragqueen_hook_generate_card_ui item_location_values patch target
    }
    for _, item_location in ipairs(item_location_values) do
      if G[item_location][_c.key] ~= nil then
        local name_in_location = G[item_location][_c.key].name
        if name_in_location ~= nil then
          if _c.name ~= name_in_location then
            _c.name = name_in_location
          end
        end
      end
    end
  end

return dragqueen_hook_generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
end





-- Hooking SMODS's .create_mod_badges()
local dragqueen_hook_suit_badge = SMODS.create_mod_badges

-- Puts a badge under a suited card indicating if it is a Light Suit, a Dark Suit, or both
function SMODS.create_mod_badges(obj, badges, ...)
  dragqueen_hook_suit_badge(obj, badges, ...)
  DRAGQUEENMOD.drag_queen_badge(obj, badges)
  DRAGQUEENMOD.card_suit_badge(obj, badges)
end



------------------------------
-- Card functions
------------------------------
-- Functions for individual cards



-- Hooking Balatro's Card.update() for handling debuffed sticker
local dragqueen_hook_card_update = Card.update

-- Cards with our debuffed sticker are considered debuffed
-- <br>Thanks to UNIK for the code
function Card.update(self, dt, ...)
  if self.ability and self.ability.dragqueen_debuffed then
    if not self.debuff and not self.area.config.collection then
      self.debuff = true
      self:set_debuff(true)
      if self.area == G.jokers then
        self:remove_from_deck(true)
      end
    end
  end
  return dragqueen_hook_card_update(self, dt, ...)
end



-- Hooking Balatro's Card.get_chip_x_mult()
local dragqueen_hook_get_chip_x_mult = Card.get_chip_x_mult

-- Forces glass cards to break if our Joker "Tipsy Queen" is in play
function Card.get_chip_x_mult(self)
  local amt = dragqueen_hook_get_chip_x_mult(self)

  if SMODS.has_enhancement(self, "m_glass") then
    local _, joker = next(SMODS.find_card('j_dragqueen_tipsy_queen', false))

    if joker then
      -- When a glass card scores, score an additional x2 mult
      amt = amt + joker.ability.extra.x_mult
    end
  end

  return amt
end



-- Hooking Balatro's Card.flip()
local dragqueen_hook_flip = Card.flip

-- Flips our two-sided Joker "Dayjob / Nightclub"
function Card.flip(self)
  local is_front_and_dayjob_nightclub = false
  
  if self.config ~= nil then
    if self.config.center ~= nil then
      if self.config.center.key == "j_dragqueen_dayjob_nightclub" and self.facing == "front" then
        is_front_and_dayjob_nightclub = true
      end
    end
  end

  if is_front_and_dayjob_nightclub == true then
    self.flipping = "f2b"
    self.facing = "back"
    self:flip()
    SMODS.calculate_context({ flip = true, card_flipped = self })
    self.pinch.x = true
  else
    dragqueen_hook_flip(self)
  end
end



-- Hooking Balatro's Card.set_sprites to handle a second soul_pos for hover
local dragqueen_hook_set_sprites = Card.set_sprites

-- Lets us render another soul_pos layer
function Card.set_sprites(self, _center, _front, ...)

  if _center then
    if _center.second_soul_pos then
      self.children.floating_sprite_2 = Sprite(
        self.T.x,
        self.T.y,
        self.T.w,
        self.T.h,
        G.ASSET_ATLAS["dragqueen_Joker_Doodles"],
        self.config.center.second_soul_pos)

      self.children.floating_sprite_2.role.draw_major = self
      self.children.floating_sprite_2.states.hover.can = false
      self.children.floating_sprite_2.states.click.can = false
      self.children.floating_sprite_2.states.visible = false
    end
  end

  dragqueen_hook_set_sprites(self, _center, _front, ...)
end



-- Hooking Balatro's Card.align() to let us handle second floating sprite
local dragqueen_hook_card_align = Card.align

-- Makes second floating sprite follow alignment
function Card.align(self)
  if self.children.floating_sprite_2 then
    self.children.floating_sprite_2.T.y = self.T.y
    self.children.floating_sprite_2.T.x = self.T.x
    self.children.floating_sprite_2.T.r = self.T.r
  end

  dragqueen_hook_card_align(self)
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
  DRAGQUEENMOD.build_custom_structure_dictionary_tooltips()
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
  DRAGQUEENMOD.build_backup_localization()

  if DRAGQUEENMOD.load_cross_mod_ours_to_theirs then
    DRAGQUEENMOD.cross_mod_ours_to_theirs()
  end

  DRAGQUEENMOD.build_custom_structure_dictionary_tooltips()
  DRAGQUEENMOD.build_dictionary()
  DRAGQUEENMOD.locally_sort_built_dictionary()

  -- Rebuilds suit map association for mods that load after this one
  DRAGQUEENMOD.mother_suit_map_set_up()
  SMODS.Ranks["dragqueen_Mother"].suit_map = DRAGQUEENMOD.mother_suitmap

  for p_card, data in pairs(G.P_CARDS) do
    if string.find(p_card, "_MOTHER") then
      data.lc_atlas = SMODS.Ranks["dragqueen_Mother"].lc_atlas
      data.hc_atlas = SMODS.Ranks["dragqueen_Mother"].hc_atlas
    end
  end
end



-- Hooking Balatro's Game:splash_screen()
-- runs after all mods are initialized
local dragqueen_hook_splash_screen = Game.splash_screen

function Game:splash_screen(...)
  DRAGQUEENMOD.last_second_code()
  dragqueen_hook_splash_screen(self, ...)
end
