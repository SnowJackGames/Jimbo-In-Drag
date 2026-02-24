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
-- i.e. `{C:clubs}Clubs{}` returns `Clubs`
---@param styledstring string
---@return string
function DRAGQUEENMOD.remove_style_modifier_codes(styledstring)
  local destyled = ""
  destyled = string.gsub(styledstring, "{.-}", "")
  return destyled
end



-- Based on the local `recurse` function in `SMODS/src/utils.lua` used by `SMODS.handle_loc_file`
-- <br>Used for merging together localization files, but can take any two tables
-- <br>If `target` is like:
--```
-- { fruits = {
--     apples = { "SweeTango", "Envy" }
--   }
-- }
--```
-- and `ref_table` is like: 
--```
-- { fruits = {
--     apples = { "Pink Lady" }, 
--     bananas = { "Goldfinger", "Fe'i" }
--   }
-- }
--```
-- Then the returned `combined_table` will become:
--```
-- { fruits = {
--     apples = { "Envy", "SweeTango", "Pink Lady" }, 
--     bananas = { "Goldfinger", "Fe'i" }
--   }
-- }
--```
---@param target table
---@param ref_table table
---@param force? boolean
---@return table | nil
---@see SMODS.handle_loc_file
function DRAGQUEENMOD.recursively_add_entries_from_one_table_into_another(target, ref_table, force)
  local combined_table = ref_table

  local recurse = DRAGQUEENMOD.recursively_add_entries_from_one_table_into_another
    if type(target) ~= 'table' then return end --this shouldn't happen unless there's a bad return value

    for k, v in pairs(target) do
      -- If the value doesn't exist *or*
      -- force mode is on and the value is not a table,
      -- change/add the thing
      if type(combined_table) ~= "nil" then
        if (not combined_table[k] and type(k) ~= 'number') or (force and ((type(v) ~= 'table') or type(v[1]) == 'string')) then
          combined_table[k] = v
        else
          recurse(v, combined_table[k])
        end
      end
    end
    
    return combined_table
  end



------------------------------
-- Getters
------------------------------



-- When given a quote table of strings,
-- pulls a random quote and returns it
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



-- Easily pulls a set and key from `G.localization.descriptions`
---@param set string Ex. `Blind`
---@param key string Ex. `bl_dragqueen_tempnamekissblind`
----@return table -- has a name string, and a text table of one or more strings
function DRAGQUEENMOD.easydescriptionslocalize(set, key)
  assert(type(set) == "string", "set passed to DRAGQUEENMOD.easydescriptionslocalize must be a string")
  assert(type(key) == "string", "set passed to DRAGQUEENMOD.easydescriptionslocalize must be a string")
  local parsed_entry = nil

  if G.localization.descriptions[set] then
    parsed_entry = G.localization.descriptions[set][key]
  end

  local back_up_entries = DRAGQUEENMOD.backup_localization_entries

  ------------------------------
  -- Finding the entry in other languages as a backup
  ------------------------------

  -- If the entry doesn't exist in the current language, maybe it's in default
  if parsed_entry == nil then
    if back_up_entries["default"].descriptions then
      if back_up_entries["default"].descriptions[set] then
        parsed_entry = back_up_entries["default"].descriptions[set][key]
      end
    end
  end

  -- If the entry doesn't exist in the current language, maybe it's in en-us?
  if parsed_entry == nil then
    if back_up_entries["default"].descriptions then
      if back_up_entries["en-us"].descriptions[set] then
        parsed_entry = back_up_entries["en-us"].descriptions[set][key]
      end
    end
  end

  -- If we still can't find the entry, then we just gotta pull from a random language
  if parsed_entry == nil then
    local language_names = {}

    for language_name, _ in pairs (back_up_entries) do
      table.insert(language_names, language_name)
    end

    for _, language in ipairs(language_names) do
      if back_up_entries[language].descriptions then
        if back_up_entries[language].descriptions[set] then
          if parsed_entry ~= nil then
            break
          else
            parsed_entry = back_up_entries[language].descriptions[set][key]
          end
        end
      end
    end
  end

  -- Final resort, there's a chance that the item is using a loc_txt to handle localization. Let's find the item by key
  if parsed_entry == nil then
    local types_of_entries = {
      "P_CENTERS",
      "P_SEALS",
      "P_TAGS",
      "P_STAKES",
      "P_BLINDS",
    }
    for _, entry_type in ipairs(types_of_entries) do
      local entry = entry_type
      if G[entry][key] then
        if G[entry][key].loc_txt then
          local loc_txt = G[entry][key].loc_txt
          if parsed_entry == nil then
            parsed_entry = loc_txt["default"]
          end
          if parsed_entry == nil then
            parsed_entry = loc_txt["en-us"]
          end
          if parsed_entry == nil then
            for _, data in pairs(loc_txt) do
              if parsed_entry then
                break
              else
                parsed_entry = data
              end
            end
          end
        end
      end
    if parsed_entry == nil then
      break
    end
    end
  end

  ------------------------------
  -- Passing entry
  ------------------------------

  -- Pass the entry if it exists
  if parsed_entry then
    return parsed_entry
  else
    error(set .. ", " .. key .. " passed to DRAGQUEENMOD.easydescriptionslocalize not found in current localization table nor default nor en-us nor any other language")
  end
end



-- Easily pulls a set and key from `G.localization.misc`
---@param set string Ex. `dictionary`
---@param key string Ex. `dragqueen_yas`
---@return table | string -- either a string, or a table of strings
function DRAGQUEENMOD.easymisclocalize(set, key)
  assert(type(set) == "string", "set passed to DRAGQUEENMOD.easymisclocalize must be a string")
  assert(type(key) == "string", "set passed to DRAGQUEENMOD.easymisclocalize must be a string")
  local parsed_entry = nil

  if G.localization.misc[set] then
    parsed_entry = G.localization.misc[set][key]
  end

  local back_up_entries = DRAGQUEENMOD.backup_localization_entries

  ------------------------------
  -- Finding the entry in other languages as a backup
  ------------------------------

  -- If the entry doesn't exist in the current language, maybe it's in default
  if parsed_entry == nil then
    if back_up_entries["default"].misc then
      if back_up_entries["default"].misc[set] then
        parsed_entry = back_up_entries["default"].misc[set][key]
      end
    end
  end

  -- If the entry doesn't exist in the current language, maybe it's in en-us?
  if parsed_entry == nil then
    if back_up_entries["default"].misc then
      if back_up_entries["en-us"].misc[set] then
        parsed_entry = back_up_entries["en-us"].misc[set][key]
      end
    end
  end


  -- If we still can't find the entry, then we just gotta pull from a random language
  if parsed_entry == nil then
    local language_names = {}

    for language_name, _ in pairs (back_up_entries) do
      table.insert(language_names, language_name)
    end

    for _, language in ipairs(language_names) do
      if back_up_entries[language].misc then
        if back_up_entries[language].misc[set] then
          if parsed_entry ~= nil then
            break
          else
            parsed_entry = back_up_entries[language].misc[set][key]
          end
        end
      end
    end
  end

  -- Final resort, there's a chance that the item is using a loc_txt to handle localization. Let's find the item by key
  if parsed_entry == nil then
    local types_of_entries = {
      "P_CENTERS",
      "P_SEALS",
      "P_TAGS",
      "P_STAKES",
      "P_BLINDS",
    }
    for _, entry_type in ipairs(types_of_entries) do
      local entry = entry_type
      if G[entry][key] then
        if G[entry][key].loc_txt then
          local loc_txt = G[entry][key].loc_txt
          if parsed_entry == nil then
            parsed_entry = loc_txt["default"]
          end
          if parsed_entry == nil then
            parsed_entry = loc_txt["en-us"]
          end
          if parsed_entry == nil then
            for _, data in pairs(loc_txt) do
              if parsed_entry then
                break
              else
                parsed_entry = data
              end
            end
          end
        end
      end
    if parsed_entry == nil then
      break
    end
    end
  end

  ------------------------------
  -- Passing entry
  ------------------------------

  -- Pass the entry if it exists
  if parsed_entry ~= nil then
    return parsed_entry
  else
    error(set .. ", " .. key .. " passed to DRAGQUEENMOD.easymisclocalize not found in current localization table nor default nor en-us nor any other language")
  end
end



-- Determines if score flames were activated
---@param context table
---@return true | nil
function DRAGQUEENMOD.final_scoring_step_slay(context)
  if context.final_scoring_step and (hand_chips * mult > G.GAME.blind.chips) then
    return true
  end
end



------------------------------
-- Setters
------------------------------



-- Determines if current deck is playing with anything other than "plain suits" (spades, hearts, clubs, diamonds)
-- <br>If so then we want to communicate this to things communicating what light and dark suits are there available
-- <br>Maybe we'll come up with a better term than "non-plain"
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
---@param type "light" | "dark"
---@return boolean
function DRAGQUEENMOD.is_suit(card, type)
  for _, v in ipairs(type == 'light' and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits) do
    if card:is_suit(v) then return true end
  end
  return false
end



---Used to check whether a card is a suit that is not plain
---<br>Plain suits are Spades, Hearts, Clubs, Diamonds
---@param card table
---@return boolean
function DRAGQUEENMOD.is_non_plain_suit(card)
  -- For things like stone cards, enhanced to have no suit
  if SMODS.has_no_suit(card) == true then return false end

  -- For things like wild cards
  if SMODS.has_any_suit(card) == true then return true end

  -- List of suits that a card is, in case it is somehow multiple
  local is_suits = {}
  local is_non_plain = false

  -- Get every suit that a card is
  for suit, _ in pairs(SMODS.Suits) do
    if card:is_suit(suit) then
      table.insert(is_suits, suit)
    end
  end

  for _, suit in ipairs(is_suits) do
    if (suit ~= "Spades") and (suit ~= "Hearts") and (suit ~= "Clubs") and (suit ~= "Diamonds") then
      is_non_plain = true
    end
  end

  return is_non_plain
end



--- Checks whether a given card is a certain rank; thanks Paperback
---@param card Card | table
---@param rank string | integer a rank's name, like "Jack" or "4", or an id like 11 or 4
---@return boolean | nil
function DRAGQUEENMOD.is_rank(card, rank)
  if not card or not card.get_id then return end
  local id = card:get_id()

  if type(rank) == "string" then
    local rank_obj = SMODS.Ranks[rank]
    return rank_obj and rank_obj.id == id
  elseif type(rank) == "number" then
    return id == rank
  end
end



-- First character of a joker key is "j"; this is added by SMODS
-- <br>Determined by how Balatro and SMODS figure out how to make a card in a variety of circumstances
---@param card? table | Card
---@param set? string
---@param key? string
---<br>
---@see SMODS.create_card
---@see SMODS.add_card
---@return boolean
function DRAGQUEENMOD.is_joker(card, set, key)
  if not (card or set or key) then return false end
  if card and not (card.ability.set == "Joker") then return false end
  if set and not ((set == "Joker")) then return false end
  if key and not (key:sub(1, 1) == "j") then return false end
  return true
end



-- Determined by how Balatro and SMODS figure out how to make a card in a variety of circumstances
-- <br><b>Please note</b>: Balatro will randomly spell "consumeable" with and without an "e": 
-- - Consumables have a `consumeable` field
-- - `c_fool` has a "consumeable" field that equals true
-- - Cards you can consume are located in area `G.consumeables`
-- - SMODS stores `SMODS.ConsumableTypes[]`
-- - In en-us, `crystal_ball` creates "+1 consumable slot"
-- - `SMODS.Challenge` and their `CalcContext` has a `consumeable?` field
-- ##### "[Oh no!](https://www.youtube.com/watch?v=CmsLicrjGRg)"
-- ***
---@param set? string
---@param key? string
---@see SMODS.create_card
---@see SMODS.add_card
---@return boolean
function DRAGQUEENMOD.is_consumable(set, key)
  if not (set or key) then return false end
  if set and not ((set == "Consumeables") or SMODS.ConsumableTypes[set]) then return false end
  if key and (G.P_CENTERS[key].consumeable == nil) then return false end
  return true
end



-- Front is usually of format `H_2` (correspends to 2 of Hearts); 
-- in base game, set is only "Playing Card", "Base", or "Enhanced",
-- but if for some reason you change create_card() that it can be allowed via adding to DRAGQUEENMOD.valid_playing_card_set_categories
---comment
---@param set? string
---@param front? string
---@param rank? string | integer
---@param suit? string
---@return boolean
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



---Gets the number of unique dark suits in a provided scoring hand
---@param scoring_hand table
---@param bypass_debuff boolean?
---@param flush_calc boolean?
---@return integer
function DRAGQUEENMOD.get_unique_dark_suits(scoring_hand, bypass_debuff, flush_calc)
  -- Set each suit's count to 0
  local dark_suits = {}

  for _, dark_suit in pairs(DRAGQUEENMOD.dark_suits) do
    dark_suits[dark_suit] = 0
  end

  -- First we cover all the non Wild Cards in the hand
  for _, card in ipairs(scoring_hand) do
    if not SMODS.has_any_suit(card) then
      for dark_suit, count in pairs(dark_suits) do
        if card:is_suit(dark_suit, bypass_debuff, flush_calc) and count == 0 then
          dark_suits[dark_suit] = count + 1
          break
        end
      end
    end
  end

  -- Then we cover Wild Cards, filling the missing suits
  for _, card in ipairs(scoring_hand) do
    if SMODS.has_any_suit(card) then
      for dark_suit, count in pairs(dark_suits) do
        if card:is_suit(dark_suit, bypass_debuff, flush_calc) and count == 0 then
          dark_suits[dark_suit] = count + 1
          break
        end
      end
    end
  end

  -- Count the amount of suits that were found
  local num_dark_suits = 0

  for _, v in pairs(dark_suits) do
    if v > 0 then num_dark_suits = num_dark_suits + 1 end
  end

  return num_dark_suits
end



---Gets the number of unique light suits in a provided scoring hand
---@param scoring_hand table
---@param bypass_debuff boolean?
---@param flush_calc boolean?
---@return integer
function DRAGQUEENMOD.get_unique_light_suits(scoring_hand, bypass_debuff, flush_calc)
  -- Set each suit's count to 0
  local light_suits = {}

  for _, light_suit in pairs(DRAGQUEENMOD.light_suits) do
    light_suits[light_suit] = 0
  end

  -- First we cover all the non Wild Cards in the hand
  for _, card in ipairs(scoring_hand) do
    if not SMODS.has_any_suit(card) then
      for light_suit, count in pairs(light_suits) do
        if card:is_suit(light_suit, bypass_debuff, flush_calc) and count == 0 then
          light_suits[light_suit] = count + 1
          break
        end
      end
    end
  end

  -- Then we cover Wild Cards, filling the missing suits
  for _, card in ipairs(scoring_hand) do
    if SMODS.has_any_suit(card) then
      for light_suit, count in pairs(light_suits) do
        if card:is_suit(light_suit, bypass_debuff, flush_calc) and count == 0 then
          light_suits[light_suit] = count + 1
          break
        end
      end
    end
  end

  -- Count the amount of suits that were found
  local num_light_suits = 0

  for _, v in pairs(light_suits) do
    if v > 0 then num_light_suits = num_light_suits + 1 end
  end

  return num_light_suits
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
