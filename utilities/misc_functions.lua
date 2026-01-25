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



-- Removes style modifier codes from a string;
-- i.e. "{C:clubs}Clubs{}" returns "Clubs"
---@param styledstring string
---@return string
function DRAGQUEENMOD.remove_style_modifier_codes(styledstring)
  local destyled = ""
  destyled = string.gsub(styledstring, "{.-}", "")
  return destyled
end


------------------------------
-- Getters
------------------------------



-- When given a quote table of strings,
-- Pulls a random quote and returns it
---@param quotes table
---@return string | nil
function DRAGQUEENMOD.get_quote(quotes)
  local quotes_to_fetch = nil
  local returnquote = nil

  -- Get from the swear or no_swear table
  if DRAGQUEENMOD.config.swears_enabled == true then
    quotes_to_fetch = quotes.swear
  else
    quotes_to_fetch = quotes.no_swear
  end

  if quotes_to_fetch then
    local current_position = 1
    local randomed_position = math.random(#quotes_to_fetch)
    for _, quote in ipairs(quotes_to_fetch) do
      if current_position == randomed_position then
        if type(quote) == "string" then
          returnquote = quote
        end
      end

      current_position = current_position + 1
    end
  end

  return returnquote
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




---@param context table
---@return true | nil
-- Determines if score flames were activated
function DRAGQUEENMOD.final_scoring_step_slay(context)
  if context.final_scoring_step and (hand_chips * mult > G.GAME.blind.chips) then
    return true
  end
end



------------------------------
-- Setters
------------------------------



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



------------------------------
-- "Is" functions
------------------------------




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



------------------------------
-- Other determiner functions
------------------------------



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
