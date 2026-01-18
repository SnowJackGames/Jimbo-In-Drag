---Registers a list of items in a custom order
---@param items table
---@param path string
function DRAGQUEENMOD.register_items(items, path)
  for i = 1, #items do
    if path and love.filesystem.getInfo(DRAGQUEENMOD.dragqueen_path_from_save_folder .. path .. "/" .. items[i] .. ".lua") then
      SMODS.load_file(path .. "/" .. items[i] .. ".lua")()
    end
  end
end

---Used to check whether a card is a light or dark suit
---@param card table
---@param type 'light' | 'dark'
---@return boolean
function DRAGQUEENMOD.is_suit(card, type)
  for _, v in ipairs(type == 'light' and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits) do
    if card:is_suit(v) then return true end
  end
  return false
end

-- Determines if current deck is playing with anything other than "plain suits" (spades, hearts, clubs, diamonds)
-- If so then we want to communicate this to things communicating what light and dark suits are there available
-- Maybe we'll come up with a better term than "non-plain"
function DRAGQUEENMOD.enable_non_plains()
  if G.GAME then
    G.GAME.NonPlain = true
  end
end

function DRAGQUEENMOD.disable_non_plains()
  if G.GAME then
    G.GAME.NonPlain = false
  end
end

---Checks if the provided suit is currently in the deck
---@param suit string
---@param ignore_wild? boolean
---@return boolean
function DRAGQUEENMOD.has_suit_in_deck(suit, ignore_wild)
  for _, v in ipairs(G.playing_cards or {}) do
    if not SMODS.has_no_suit(v) and (v.base.suit == suit or (not ignore_wild and v:is_suit(suit))) then
      return true
    end
  end
  return false
end

-- Checks if non-plain cards are allowed to spawn
function DRAGQUEENMOD.non_plain_in_pool()
  -- Returns true if in a run and NonPlain has been activated
  if G.GAME and G.GAME.NonPlain then
    return true
  end
  -- In case a spectrum somehow gets played without enabling non_plains, check directly:
  local spectrum_played = false
  if G and G.GAME and G.GAME.hands then
    for k, v in pairs(G.GAME.hands) do
      if string.find(k, "Spectrum", nil, true) or string.find(k, "Specflush", nil, true) then
        if G.GAME.hands[k].played > 0 then
          spectrum_played = true
          break
        end
      end
    end
  end
  return spectrum_played
end

--- @return boolean
function DRAGQUEENMOD.has_modded_suit_in_deck()
  for k, v in ipairs(G.playing_cards or {}) do
    local is_modded = true
    for _, suit in ipairs(DRAGQUEENMOD.base_suits) do
      if v.base.suit == suit then
        is_modded = false
      end
    end

    if not SMODS.has_no_suit(v) and is_modded then
      return true
    end
  end
  return false
end

---Gets the number of unique suits in a provided scoring hand
---@param scoring_hand table
---@param bypass_debuff boolean?
---@param flush_calc boolean?
---@return integer
function DRAGQUEENMOD.get_unique_suits(scoring_hand, bypass_debuff, flush_calc)
  -- Set each suit's count to 0
  local suits = {}

  for k, _ in pairs(SMODS.Suits) do
    suits[k] = 0
  end

  -- First we cover all the non Wild Cards in the hand
  for _, card in ipairs(scoring_hand) do
    if not SMODS.has_any_suit(card) then
      for suit, count in pairs(suits) do
        if card:is_suit(suit, bypass_debuff, flush_calc) and count == 0 then
          suits[suit] = count + 1
          break
        end
      end
    end
  end

  -- Then we cover Wild Cards, filling the missing suits
  for _, card in ipairs(scoring_hand) do
    if SMODS.has_any_suit(card) then
      for suit, count in pairs(suits) do
        if card:is_suit(suit, bypass_debuff, flush_calc) and count == 0 then
          suits[suit] = count + 1
          break
        end
      end
    end
  end

  -- Count the amount of suits that were found
  local num_suits = 0

  for _, v in pairs(suits) do
    if v > 0 then num_suits = num_suits + 1 end
  end

  return num_suits
end

-- Fetches the current used prefix for a loaded mod if that prefix has recently changed
---@param name string
---@param guessedprefix string | nil
function DRAGQUEENMOD.getprefix(name, guessedprefix)
  assert(next(SMODS.find_mod(name)), "mod \"" .. name .. "\" not found in SMODS.find_mod()")
  local foundprefix = SMODS.find_mod(name)[1].prefix or guessedprefix
  return foundprefix
end

---@param set string
---@param key string
---@return table
-- Easily pulls a set and key from G.localization.descriptions
-- Ex. "Blind","bl_dragqueen_tempnamekissblind"
-- Returned table has a name string, and a text table of one or more strings
function DRAGQUEENMOD.easydescriptionlocalize(set, key)
  local localized
  assert(G.localization.descriptions[set], "Could not find " .. set .. " in descriptions")
  localized = assert(G.localization.descriptions[set][key], "Could not find " .. key .. " in " .. set)
  return localized
end

---@param set string
---@param key string
---@return table | string
-- Easily pulls a set and key from G.localization.misc
-- Ex. "dictionary","dragqueen_yas"
-- Returned table is either a string, or a table of strings
function DRAGQUEENMOD.easymisclocalize(set, key)
  local localized
  assert(G.localization.misc[set], "Could not find " .. set .. " in localization.misc")
  localized = assert(G.localization.misc[set][key], "Could not find " .. key .. " in " .. set)
  return localized
end

---@param array table
---@param value any
---@return number | nil
-- Return the first index with the given value (or nil if not found)
function DRAGQUEENMOD.indexof(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

---@param context table
---@return true | nil
-- Determines if score flames were activated
function DRAGQUEENMOD.final_scoring_step_slay(context)
  if context.final_scoring_step and (hand_chips * mult > G.GAME.blind.chips) then
    return true
  end
end

-- Lets Balatro load unusual Unicode characters for fun tooltip stuff
function DRAGQUEENMOD.font_symbols()
  -- "symbol-font.ttf" is a copy of the balatro m6x11plus.ttf font, with added characters from Bunco,
  -- and added characters created from SVG icons from BigBlueTermPlusNerdFont-Regular (see BigBlueTermPlusNerdFont-RegularSVG-assets-license.txt in /assets/fonts)
  -- used for suit symbols (see: /lovely/suitsymbols.toml)
  local font_location = DRAGQUEENMOD.dragqueen_path_from_save_folder .. "assets/fonts/"
  local symbol_font = love.graphics.newFont(font_location .. "symbol-font.ttf", G.TILESIZE * 10)
  local nerd_font = love.graphics.newFont(font_location .. "BigBlueTermPlusNerdFontPropo-Regular.ttf", G.TILESIZE * 8)
  for i, v in ipairs(G.FONTS) do
    G.FONTS[i].FONT:setFallbacks(symbol_font, nerd_font)
  end
end

-- Removes style modifier codes from a string;
-- i.e. "{C:clubs}Clubs{}" returns "Clubs"
---@param styledstring string
---@return string
function DRAGQUEENMOD.remove_style_modifier_codes(styledstring)
  local destyled = ""
  destyled = string.gsub(styledstring, "{.-}", "")
  return destyled
end


-- Updates the current value of a "wavy color" (a color that shifts between two or more colors)
-- Make sure code is efficient because it is called every tick;
-- i.e. reduce calls to global
function DRAGQUEENMOD.wavy_color_updater(time)
  -- Please note how beautiful and smart I, Kassandra, am for figuring this all out
  local wavy_colors = {}
  local sosopaac = {}
  local sosopaac_index = 0
  local sine_colors = DRAGQUEENMOD.sine_colors
  local pi = math.pi
  local pairs = pairs
  local ipairs = ipairs

  -- Builds set_of_sets_of_points_along_a_circle for the first time
  if DRAGQUEENMOD.set_of_sets_of_points_along_a_circle == nil then
    if sine_colors ~= nil then
      for colorsetname, set_of_individual_colors in pairs(sine_colors) do
        if colorsetname ~= nil then
          -- Typechecking
          assert(type(colorsetname) == "string", "DRAGQUEENMOD.wavy_color_updater was sent colorsetname that is not a string")
          assert(type(set_of_individual_colors) == "table", "DRAGQUEENMOD.wavy_color_updater was sent a color " .. colorsetname.. " with 'set_of_individual_colors' that is not a table")

          local points = 0

          -- More typechecking and also determining the number of colors in the set
          for _, individual_color in ipairs(set_of_individual_colors) do
            local passed_individual_color = individual_color

            -- Could be a string to be passed to loc_colour, or a color table
            if type(passed_individual_color) == "string" then
              passed_individual_color = loc_colour(individual_color)
            end

            -- Make sure calculating 
            assert(type(passed_individual_color) == "table", "DRAGQUEENMOD.wavy_color_updater was sent a color of improper format in " .. colorsetname)
            for _, value in pairs(passed_individual_color) do
              assert(type(tonumber(value)) == "number", "DRAGQUEENMOD.wavy_color_updater was sent a color of improper format in " .. colorsetname)
            end
            points = points + 1
          end

          local set_of_points_along_a_circle = {}
          local pointdistance = 2 * pi
          local currentdistance = 0

          -- Divide the circle into the number of colors there are
          pointdistance = pointdistance / points

          for i = 1, points, 1 do
            set_of_points_along_a_circle[i] = currentdistance
            currentdistance = currentdistance + pointdistance
          end

          table.insert(sosopaac, set_of_points_along_a_circle)
        end
      end
    end

    -- Now set_of_sets_of_points_along_a_circle doesn't need to build again
    DRAGQUEENMOD.set_of_sets_of_points_along_a_circle = sosopaac
  else
    sosopaac = DRAGQUEENMOD.set_of_sets_of_points_along_a_circle
  end

  if sine_colors ~= nil then

    local unit_circle_position = 0
    local fmod = math.fmod
    local gammaToLinear = love.math.gammaToLinear
    local linearToGamma = love.math.linearToGamma
    local type = type
    local loc_colour = loc_colour

    for colorsetname, set_of_individual_colors in pairs(sine_colors) do
      if colorsetname ~= nil then
        sosopaac_index = sosopaac_index + 1
        local sosopaac_index_size = #sosopaac[sosopaac_index]
        
        -- If there's only one color there's no reason to mix it
        -- This is not intended usage of wavy_color_updater function however
        if sosopaac_index_size == 0 then    -- Skip
        elseif sosopaac_index_size == 1 then
          wavy_colors[colorsetname] = set_of_individual_colors[1]
        else
          -- Given unit_circle_position, find the two individual_colors that are closest
          -- Setting "before" to be the last color initially
          local point_before = sosopaac_index_size
          local point_after = 1

          -- We need slower speed if there's more colors
          local speed = 4 / (sosopaac_index_size)

          -- Find the unit_circle_position given time, in radians;
          -- value loops from 0 to 2pi
          unit_circle_position = fmod(time * speed, 2 * pi)

          -- Finds the latest color_point that unit_circle_position is at or after
          for color_point, point_radian in ipairs(sosopaac[sosopaac_index]) do
            if unit_circle_position == point_radian then
              point_before = color_point
              point_after = color_point
            elseif unit_circle_position > point_radian then
              point_before = color_point
              point_after = point_before + 1
            end
          end

          -- If point_after is beyond the number of points in the circle, it wraps to point 1
          if point_after > #sosopaac[sosopaac_index] then
            point_after = 1
          end

          local point_before_radians = sosopaac[sosopaac_index][point_before]
          local point_after_radians = sosopaac[sosopaac_index][point_after]

          if point_after_radians == 0 then
            point_after_radians = 2 * pi
          end
          
          local color_before = set_of_individual_colors[point_before]
          local color_after = set_of_individual_colors[point_after]
          local color_proportion = 0

          -- If colors are strings, then pull from loc_colour
          if type(color_before) == "string" then color_before = loc_colour(color_before) end
          if type(color_after) == "string" then color_after = loc_colour(color_after) end

          -- Don't divide by zero
          if (point_after_radians - point_before_radians) == 0 then
            color_proportion = 0
          else
            color_proportion = (unit_circle_position - point_before_radians) / (point_after_radians - point_before_radians)
          end

          -- "Degamma" (convert to linear sRGB) the colors before being mixed
          local degammaed_color_before = {0,0,1,1}
          local degammaed_color_after = {1,0,0,1}
          degammaed_color_before[1], degammaed_color_before[2], degammaed_color_before[3] = gammaToLinear(color_before[1], color_before[2], color_before[3])
          degammaed_color_after[1], degammaed_color_after[2], degammaed_color_after[3] = gammaToLinear(color_after[1], color_after[2], color_after[3])

          -- Alpha channel doesn't change when degammaed
          degammaed_color_before[4] = color_before[4]
          degammaed_color_after[4] = color_after[4]

          -- Note the order here when sent to mix_colours()
          local mixed_color = mix_colours(degammaed_color_after, degammaed_color_before, color_proportion)

          -- "Regamma" (convert to non-linear sRGB) the color after being mixed
          mixed_color[1], mixed_color[2], mixed_color[3] = linearToGamma(mixed_color[1], mixed_color[2], mixed_color[3])

          -- The degamma to regamma technique comes from https://archive.is/WfGUU
          -- If the two colors are red (FF0000) and green (00FF00), without converting from gamma to linear and back
          -- the midpoint is a murky brown
          -- With gamma awareness the midpoint is instead a yellowish color that preserves brightness

          wavy_colors[colorsetname] = mixed_color
        end
      end
    end
  end

  return wavy_colors
end

--- Tries to spawn a Joker, Consumable, or Playing Card, ensuring
--- that there is space available, using the respective buffer.
--- DOES NOT TAKE INTO ACCOUNT ANY OTHER AREAS
--- @param args CreateCard | { card: Card?, strip_edition: boolean? } | { instant: boolean?, func: function? } info:
--- Either a table passed to SMODS.create_card, which will create a new card.
--- Or a table with 'card', which will copy the passed card and remove its edition based on 'strip_edition'.
--- @param saveroom? integer info:
--- if slots (in consumables or jokers) need to be reserved (for perhaps something immediately spawning in the slot afterwards)
--- @return boolean? spawned whether the card was able to spawn
--- Thanks Paperback
function DRAGQUEENMOD.try_spawn_card(args, saveroom)
  -- As best that we can, let's prevent code from spilling through SMODS.add_card, temp_create_card, get_current_pool etc
  assert(args.set or args.key or args.card or args.instant or args.area or args.soulable or args.front or args.rank or args.suit, "missing minimum info for DRAGQUEENMOD.try_spawn_card()")

  local is_joker = DRAGQUEENMOD.is_joker(args.card, args.set, args.key)
  local is_playing_card = DRAGQUEENMOD.is_playing_card(args.set, args.front, args.rank, args.suit)
  local is_consumable = DRAGQUEENMOD.is_consumable(args.set, args.key)
  local setsaveroom = saveroom or 0

  -- Pulls from Balatro code, so "consumable" here spelt with an "e"
  local area = args.area or (is_joker and G.jokers) or (is_consumable and G.consumeables)
  local buffer = area == G.jokers and 'joker_buffer' or 'consumeable_buffer'

  -- It has to be one of three
  if not (is_joker or is_playing_card or is_consumable) then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is neither a joker, playing card, nor consumable")
  end

  -- Notice about key / set handling by create_card() 
  if args.key and (args.set == "Base") and (args.key ~= "c_base") then
    print("Warning: Attempting to spawn a base card with an incompatible key, create_card() will ignore key")
  end

  local should_spawn = false
  if is_playing_card then should_spawn = true
  else
    if not area then
      error("DRAGQUEENMOD.try_spawn_card() can't spawn joker or consumable without an area, or can't reach G.jokers or G.consumeables")
    else
      if is_joker and ((#area.cards + G.GAME["joker_buffer"] + setsaveroom) < area.config.card_limit) then should_spawn = true end
      if is_consumable and ((#area.cards + G.GAME["consumeable_buffer"] + setsaveroom) < (area.config.card_limit)) then should_spawn = true end
    end
  end

  -- If it's a playing card we don't have to worry about consumable or joker slots
  if should_spawn then
    local added_card
    local function add()
      if args.card and area then
        added_card = copy_card(args.card, nil, nil, nil, args.strip_edition)
        added_card:add_to_deck()
        area:emplace(added_card)
      else
        added_card = SMODS.add_card(args)
      end
    end
    
    if args.instant then
      add()
    else
      G.GAME[buffer] = G.GAME[buffer] + 1

      G.E_MANAGER:add_event(Event {
        func = function()
          add()
          G.GAME[buffer] = 0
          return true
        end
      })
    end

    if args.func and type(args.func) == "function" then
      args.func(added_card)
    end

    return true
  end
end

-- Attempts to create a tarot that converts cards to the inputted suit
---@param suit string
---@param count integer
---@param saveroom? integer info: 
-- In case space needs to be reserved, like if this effect was generated by
-- something about to enter the consumables zone.
-- If suit is "random", then it gives a random suit-converting tarot card, built in cross-mods.lua
function DRAGQUEENMOD.accessorize(suit, count, saveroom)
  local tarot = ""
  local reservespace = saveroom or 0
  
  if suit == ("dragqueen_pumps") or suit == ("dragqueen_purses") then
    print("Placeholder, Jimbo In Drag suits not existant yet")
    suit = "random"
  end
  -- To get a random suit tarot in our table, we have to iterate to find the length,
  -- determine a random position, then iterate again until we can retrieve the suit
  -- at that position
  local function random_tarot_suit()
    local length = 0
    for _, _ in pairs(DRAGQUEENMOD.suits_to_tarot) do
      length = length + 1
    end
    local current_position = 1
    local randomed_position = math.random(length)
    for u, v in pairs(DRAGQUEENMOD.suits_to_tarot) do
      if current_position == randomed_position then tarot = v end
      current_position = current_position + 1
    end
    return tarot
  end

  if suit ~= "random" then
    tarot = assert(DRAGQUEENMOD.suits_to_tarot[suit], tostring(suit) .. " not found in DRAGQUEENMOD.suits_to_tarot")
  end

  for i = 1, count, 1 do
    if suit == "random" then
      tarot = random_tarot_suit()
    end

    DRAGQUEENMOD.try_spawn_card({ key = tarot}, reservespace)
  end
end


-- First character of a joker key is j; this is added by SMODS
-- determined by how Balatro and SMODS figure out how to make a card in a variety of circumstances
-- see common_events.lua:create_card, SMODS.create_card, SMODS.add_card
function DRAGQUEENMOD.is_joker(card, set, key)
  if not (card or set or key) then return false end
  if card and not (card.ability.set == "Joker") then return false end
  if set and not ((set == "Joker")) then return false end
  if key and (not G.P_CENTERS[key]) and (not key:sub(1, 1) == 'j') then return false end
  return true
end

---determined by how Balatro and SMODS figure out how to make a card in a variety of circumstances
-- see common_events.lua:create_card, SMODS.create_card, SMODS.add_card
-- PLEASE NOTE: Balatro will randomly spell "consumeable" with and without an "e": 
-- Consumables have a "consumeable" field;
-- c_fool has a "consumeable" field that equals true;
-- Cards you can consume are located in area "G.consumeables";
-- SMODS stores "SMODS.ConsumableTypes[]";
-- in en-us, crystal_ball creates "+1 consumable slot";
-- SMODS.Challenge and their CalcContext has a "consumeable?" field;
-- https://www.youtube.com/watch?v=CmsLicrjGRg
---@param set any
---@param key any
---@return boolean
function DRAGQUEENMOD.is_consumable(set, key)
  if not (set or key) then return false end
  if set and not ((set == "Consumeables") or SMODS.ConsumableTypes[set]) then return false end
  if key and (G.P_CENTERS[key].consumeable == nil) then return false end
  return true
end


-- Front is usually of format H_2 (correspends to 2 of Hearts); 
-- in base game, set is only "Playing Card", "Base", or "Enhanced",
-- but if for some reason you change create_card() that it can be allowed via adding to DRAGQUEENMOD.valid_playing_card_set_categories
function DRAGQUEENMOD.is_playing_card(set, front, rank, suit)
  if not (set or front or rank or suit) then return false end
  if set and not DRAGQUEENMOD.indexof(DRAGQUEENMOD.valid_playing_card_set_categories, set) then return false end
  if front and not G.P_CARDS[front] then return false end
  if rank and not SMODS.Ranks[rank] then return false end
  if suit and not SMODS.Suits[suit] then return false end
  return true
end
