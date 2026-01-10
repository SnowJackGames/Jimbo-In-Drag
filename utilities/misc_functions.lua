---Registers a list of items in a custom order
---@param items table
---@param path string
function DRAGQUEENMOD.register_items(items, path)
  for i = 1, #items do
    if path and love.filesystem.getInfo(DRAGQUEENMOD.dragqueen_path_from_save_folder .. path .. "/" .. items[i] .. ".lua") then 
      -- print("loading: " .. path .. "/" .. items[i] .. ".lua")
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
  if G.GAME then G.GAME.NonPlain = true
  end
end

function DRAGQUEENMOD.disable_non_plains()
  if G.GAME then G.GAME.NonPlain = false
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