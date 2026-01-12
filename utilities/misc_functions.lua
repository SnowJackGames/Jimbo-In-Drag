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
      if string.find(k, "Spectrum", nil, true) then
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

-- Updates the current value of a "wavy color" (color that shifts between two colors)
-- sinusoidally to Balatro's "clock"
function DRAGQUEENMOD.wavy_color_updater(time)
  local wavy_colors = {}
  for color, v in pairs(DRAGQUEENMOD.sine_colors) do
    wavy_colors[color] = mix_colours(v[1], v[2], (0.5 * (1 + math.sin(time * 1.5))))
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
      -- TODO: for spawning consumables can't seem to get "consumeable_buffer" to work properly,
      -- if try_spawn_card is called to make multiple consumables in a row
      -- joker_buffer seems to work okay so... i dunno
      -- need to figure out how it actually works
      
      -- if is_joker then print("joker") end
      -- if is_consumable then print("consumeable") end
      -- print(#area.cards)
      -- if is_joker then print(G.GAME["joker_buffer"]) end
      -- if is_consumable then print(G.GAME["consumeable_buffer"]) end
      -- print(area.config.card_count)
      -- print(area.config.card_limit)
      -- print()
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

--- Attempts to create a tarot that converts cards to the inputted suit
---@param suit string
---@param count integer
function DRAGQUEENMOD.accessorize(suit, count, saveroom)
  local tarot = assert(DRAGQUEENMOD.suits_to_tarot[suit], tostring(suit) .. " not found in DRAGQUEENMOD.suits_to_tarot")
  for i = 1, count, 1 do
    DRAGQUEENMOD.try_spawn_card({ key = tarot})
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
