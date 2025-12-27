---Registers a list of items in a custom order
---@param items table
---@param path string
function DRAGQUEENMOD.register_items(items, path)
  for i = 1, #items do
    if path and love.filesystem.getInfo(path .. "/" .. items[i] .. ".lua") then 
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

function DRAGQUEENMOD.non_plain_in_pool()
  if G.GAME and G.GAME.NonPlain then return true
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

---@param set string
---@param key string
---@return table
-- Easily pulls a set and key from G.localization.descriptions
-- Ex. "Blind","bl_dragqueen_tempnamekissblind"
-- Returned table has a name string, and a text table of one or more strings
function DRAGQUEENMOD.easydescriptionlocalize(set, key)
  local localized
  assert(G.localization.descriptions[set], "Could not find " .. set " in localization.descriptions")
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
  assert(G.localization.misc[set], "Could not find " .. set " in localization.misc")
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
function  DRAGQUEENMOD.final_scoring_step_slay(context)
  if context.final_scoring_step and (hand_chips * mult > G.GAME.blind.chips) then
    return true
  end
end