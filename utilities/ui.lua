-- Create config UI
SMODS.current_mod.config_tab = function()
    return {
    }
end


-- Create Credits tab in our mod UI
SMODS.current_mod.extra_tabs = function()
end

-- Create collection entries for Kisses


-- Returns a table that can be inserted into info_queue to show all suits of the provided type
--- @param type "plain" | "light" | "dark" | "accessory" | "exotic" | "proud" | "night" | "treat" | "magic" | "stained"
--- @return table
function DRAGQUEENMOD.suit_tooltip(type)
    -- every type but light and dark has a clear-cut answer
    -- if type is light or dark:
    -- if the only suits in play (i think in G.GAME?) are plain (Clubs, Hearts, Spades, Diamonds)
    -- then only show G.localization.descriptions.dragqueen_dark_suits_vanilla.
    -- or etc light_suits_vanilla
    -- HOWEVER: if there are other suits in play then we gotta check each mod
    -- if *one* of the suits from a cross mod is in play, consider both of them in play
    -- you'll have to reference G.localization.grammar for 
    -- see the en-us.lua notes
    return table
end


-- Kiss tooltip, if we only have one then add to stickers
-- But if there's different types then can add to its own 


-- Anything else, like for a UI to select a particular Drag Queen joker