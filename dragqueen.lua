-- Use "color", not "colour" etc
-- Exception is when referencing specific variables in Balatro's source code,
-- Which is coded in Canadian
-- Mod's name "Drag Queen Balatro Mod" not final
-- Search for "placeholder" or "tempname" (any capitalization) for placeholder text

DRAGQUEENMOD = {}

-- Load utility functions into DRAGQUEENMOD
SMODS.load_file("utilities/definitions.lua")()
SMODS.load_file("utilities/misc_functions.lua")()
SMODS.load_file("utilities/cross-mod.lua")()
SMODS.load_file("utilities/ui.lua")()



-- Load the atlases
SMODS.load_file("content/atlas.lua")()


-- Check for Cross-Mod Content
-- Cross-Mod Content
if SMODS.config.cross_mod_enabled then
    DRAGQUEENMOD.cross_mod_content_register()
end

-- Load Contents of Drag Queen Mod
-- Core Content
DRAGQUEENMOD.register_items(DRAGQUEENMOD.SUITS, "content/Suits")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.RANKS, "content/Ranks")
if DRAGQUEENMOD.should_load_spectrum_items() then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.POKER_HANDS, "content/Poker_Hands")
end

-- Modifiers
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.ENHANCEMENTS, "content/Modifiers/Enhancements")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.EDITIONS, "content/Modifiers/Editions")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.STICKERS, "content/Modifiers/Stickers")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.KISSES, "content/Modifiers/Kisses")


-- Consumables
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.PLANETS, "content/Consumables/Planets")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.TAROT, "content/Consumables/Tarot")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.SPECTRALS, "content/Consumables/Spectrals")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.VOUCHERS, "content/Consumables/Vouchers")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.PACKS, "content/Consumables/Packs")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.CONSUMABLES.TAGS, "content/Consumables/Tags")


-- Jokers
if DRAGQUEENMOD.config.jokers_enabled then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.JOKERS,"content/Jokers")
end

-- Decks
if DRAGQUEENMOD.config.decks_enabled then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.DECKS,"content/Decks")
end

-- Blinds
if DRAGQUEENMOD.config.blinds_enabled then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.BLINDS,"content/Blinds")
end

-- Skins
if DRAGQUEENMOD.config.skins_enabled then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.SKINS,"content/Skins")
end

-- Vanilla Reworks
if DRAGQUEENMOD.config.vanilla_reworks_enabled then
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.VANILLA_REWORKS,"")
end

-- I don't understand this part but apply our config to particular findable objects?
-- local objects = {}


-- for _, v in pairs(SMODS.Centers) do
--     objects[#objects+1] = {obj = v, center = true}
-- end

-- for _, v in pairs(SMODS.Tags) do
--     objects[#objects+1] = {obj = v, center = true}
-- end