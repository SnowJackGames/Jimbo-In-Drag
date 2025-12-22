DRAGQUEENMOD = {}

-- Load utility functions into DRAGQUEENMOD
SMODS.load_file("utilities/definitions.lua")()
SMODS.load_file("utilities/cross-mod.lua")()

-- Load the atlases
SMODS.load_file("content/atlas.lua")()

-- Load Content, .load not yet implemented
if DRAGQUEENMOD.config.jokers_enabled then
    DRAGQUEENMOD.load("content/Jokers")
end



DRAGQUEENMOD.load("content/Jokers")
DRAGQUEENMOD.load("content/Suits")
DRAGQUEENMOD.load("content/Ranks")
DRAGQUEENMOD.load("content/Decks")
DRAGQUEENMOD.load("content/Blinds")
DRAGQUEENMOD.load("content/Modifiers")