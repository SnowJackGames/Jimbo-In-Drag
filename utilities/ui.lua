-- Create config UI
SMODS.current_mod.config_tab = function()
    return {
    }
end


-- Create Credits tab in our mod UI
SMODS.current_mod.extra_tabs = function()
end

-- Create collection entries for Kisses

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

-- Returns a table that can be inserted into info_queue to show all suits of the provided type
--- @param type
--- | "plain"
--- | "light"
--- | "dark"
--- | "accessory"
--- | "exotic"
--- | "proud"
--- | "night"
--- | "treat"
--- | "magic"
--- | "stained"
--- @return table
function DRAGQUEENMOD.suit_tooltip(type)
  local key = "dragqueen_"
  local colours = {}

  local modprefixes = {
    ["exotic"] = "bunco_",
    ["proud"] = "paperback_",
    ["night"] = "six_",
    ["treat"] = "minty_",
    ["magic"] = "mtg_",
    ["stained"] = "ink_"
  }

  -- convention in our localization file for referencing other mods
  -- ex. dragqueen_bunco_exotic_suits
  for modtype, modprefix in pairs(modprefixes) do
    if modtype == type then
      key = key .. modprefix .. type
    end
  end

    -- every type but light and dark has a clear-cut answer
    -- if type is light or dark:
    -- if the only suits in play (i think in G.GAME?) are plain (Clubs, Hearts, Spades, Diamonds)
    -- then only show G.localization.descriptions.dragqueen_dark_suits_vanilla.
    -- or etc light_suits_vanilla
    -- HOWEVER: if there are other suits in play then we gotta check each mod
    -- if *one* of the suits from a cross mod is in play, consider all cross mod suits in play
    -- you'll have to reference G.localization.grammar for list
    -- see the en-us.lua notes
    if type == "dark" or "light" then
      local suits = type == "light" and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits
      -- if playing with only plain suits output plain light and dark suits
      -- if playing with non-plain suits output all light and dark suits available
      -- checking if a mod exists with next(SMODS.find_mod("Bunco")) or 
      -- put coordinators in proper list place

    end
  


  return {
    -- Balatro's functions/common_events.lua:function generate_card_ui() builds a full_UI_table.name
    -- which is parsed with Balatro's functions/misc_functions.lua:function localize(args, misc_cat)
    -- The easiest way to find a table inside of Balatro's localization/en-us.lua description table (or any other language file)
    -- is to use "name_text" when this erturn is passed to full_UI_table.name and then localize()
    -- "Colours" here comes from Balatro's own Canadian code
    type = 'name_text',
    set = "Suit",
    key = key .. "_suits",
    vars = {
      colours = colours
    }
  }
end


-- Kiss tooltip, if we only have one then add to stickers
-- But if there's different types then can add to its own 


-- Anything else, like for a UI to select a particular Drag Queen joker