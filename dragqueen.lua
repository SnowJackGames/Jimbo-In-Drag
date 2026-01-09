-- Use "color", not "colour" etc
-- Exception is when referencing specific variables in Balatro's source code,
-- Which is coded in Canadian
-- Mod's name "Drag Queen Balatro Mod" not final
-- Search for "placeholder" or "tempname" (any capitalization) for placeholder text

DRAGQUEENMOD = {}

-- Load utility functions into DRAGQUEENMOD
SMODS.load_file("utilities/definitions.lua")()
SMODS.load_file("utilities/misc_functions.lua")()
SMODS.load_file("utilities/content_patches.lua")()
SMODS.load_file("utilities/cross-mod.lua")()
SMODS.load_file("utilities/ui.lua")()
SMODS.load_file("utilities/hooks.lua")()

-- Do a bit of font magic so that Balatro can support unusual Unicode characters
DRAGQUEENMOD.font_symbols()

-- Load the atlases
SMODS.load_file("content/atlas.lua")()


-- Check for Cross-Mod Content
-- Cross-Mod Content
if DRAGQUEENMOD.config.cross_mod_enabled then
  DRAGQUEENMOD.cross_mod_content_register()
end

-- Load Contents of Drag Queen Mod
-- Core Content
DRAGQUEENMOD.register_items(DRAGQUEENMOD.SUITS, "content/Suits")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.RANKS, "content/Ranks")

-- Modifiers
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.ENHANCEMENTS, "content/Modifiers/Enhancements")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.EDITIONS, "content/Modifiers/Editions")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.STICKERS, "content/Modifiers/Stickers")
DRAGQUEENMOD.register_items(DRAGQUEENMOD.MODIFIERS.KISSES, "content/Modifiers/Kisses")


-- Consumables
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

-- Apply our config to particular findable objects
local objects = {}

for _, v in pairs(SMODS.Centers) do
  objects[#objects+1] = {obj = v, center = true}
end

for _, v in pairs(SMODS.Tags) do
  objects[#objects+1] = {obj = v, center = true}
end

-- Apply said config to each valid object
for _, v in ipairs(objects) do
  local obj = v.obj
  if obj and type(obj) == "table" and obj.dragqueen then
    local func_ref = obj.in_pool or function() return true end
    local config = obj.dragqueen

    if config.requires_pumps or config.requires_purses then
      config.requires_custom_suits = true
    end

    config.requirements = {}
    for k, _ in pairs(config) do
      local data = DRAGQUEENMOD.requirement_map[k]
      if data then
        table.insert(config.requirements, data)
      end
    end

    -- Hook the in_pool function, adding extra logic depending on the
    -- config provided by this center
    obj.in_pool = function(self, args)
      local ret, dupes = func_ref(self, args)

      for _, req in ipairs(config.requirements) do
        ret = ret and DRAGQUEENMOD.config[req.setting]
      end

      if config.requires_pumps then
        ret = ret and DRAGQUEENMOD.has_suit_in_deck("dragqueen_Pumps", true)
      end

      if config.requires_purses then
        ret = ret and DRAGQUEENMOD.has_suit_in_deck("dragqueen_Purses", true)
      end

      if config.requires_spectrum_or_suit then
        ret = ret and (DRAGQUEENMOD.spectrum_played() or DRAGQUEENMOD.has_modded_suit_in_deck())
      end

      return ret, dupes
    end
  end
end