-- Use "color", not "colour" etc
-- Exception is when referencing specific variables in Balatro's source code,
-- Which is coded in canadian
-- Mod's name "Drag Queen Balatro Mod" not final
-- Search for "placeholder" or "tempname" (any capitalization) for placeholder text

DRAGQUEENMOD = {}

-- Load utility functions into DRAGQUEENMOD
SMODS.load_file("utilities/definitions.lua")()
SMODS.load_file("utilities/misc_functions.lua")()
SMODS.load_file("utilities/ui.lua")()
SMODS.load_file("utilities/cross-mod.lua")()


-- Load the atlases
SMODS.load_file("content/atlas.lua")()


-- Check for Cross-Mod Content
DRAGQUEENMOD.cross_mod_content_register()


-- Load Contents of Drag Queen Mod
-- Core Content
DRAGQUEENMOD.register_items(DRAGQUEENMOD.SUITS, "content/Suits")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.RANKS, "content/Ranks")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.POKER_HANDS, "content/Poker_Hands")


-- Modifiers
DRAGQUEENMOD.register_items(DRAGQUEENMOD.ENHANCEMENTS, "content/Modifiers/Enhancements")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.EDITIONS, "content/Modifiers/Editions")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.STICKERS, "content/Modifiers/Stickers")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.KISSES, "content/Modifiers/Kisses")


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
    DRAGQUEENMOD.register_items(DRAGQUEENMOD.VANILLA_REWORKS,"content/Skins")
end

-- Cross-Mod Content
if DRAGQUEENMOD.confi.cross_mod_enabled then
    DRAGQUEENMOD.cross_mod_content_register()
end
