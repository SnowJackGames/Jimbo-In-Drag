-- Talisman compatibility
DRAGQUEENMOD.to_big = to_big or function(n)
  return n
end

DRAGQUEENMOD.to_number = to_number or function(n)
  return n
end

-- Searching for other mods for cross-mod content and integration
function DRAGQUEENMOD.cross_mod_content_register()
-- Bunco
  if next(SMODS.find_mod("Bunco")) then
    local prefix = DRAGQUEENMOD.getprefix("Bunco", "bunc")
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Halberds")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Fleurons")
    DRAGQUEENMOD.exotic_suits = {prefix .. "_Halberds", prefix .. "_Fleurons"}
    
    DRAGQUEENMOD.Bunco_joker_patch()

    -- Don't duplicate Glitter tag, edition
    -- Add consumer edition tags
    -- Add Mothers
    -- Add Stylophone audio
  end

  -- Paperback
  if next(SMODS.find_mod("paperback")) then
    local prefix = DRAGQUEENMOD.getprefix("paperback", "paperback")

    -- Adds their suits to our definitions of light and dark and proud
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crowns")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    DRAGQUEENMOD.proud_suits = {prefix .. "_Crowns", prefix .. "_Stars"}

    -- If their definition of light and dark don't already reference our suits, they now do
    -- We have to find their definition relative to the player's mod install
    local paperback_path = tostring(SMODS.Mods["paperback"].path)
    local paperback_cross_mod_path = string.gsub(paperback_path, ".paperback.lua", "") .. "utilities/cross-mod.lua"
    local paperback_cross_mod_file = assert(io.open(paperback_cross_mod_path,"r"), "Couldn't understand Paperback path")
    -- If there's no mention of the our mod, then they're probably not implementing us
    -- A silly fix but I think grounded in logic
    if paperback_cross_mod_file then
      local paperback_cross_mod_content = paperback_cross_mod_file:read("*a")
      if not string.find(paperback_cross_mod_content, "dragqueen") then
        if PB_UTIL then
          PB_UTIL.is_suit = DRAGQUEENMOD.is_suit
          PB_UTIL.suit_tooltip = DRAGQUEENMOD.suit_tooltip
        end
      end
    end


    -- Add paperclips to modifiers
    -- Add their ranks
    -- Add Mothers, which also count as Apostles
  end

  -- Six Suits
  if next(SMODS.find_mod("SixSuits")) then
    local prefix = SMODS.find_mod("SixSuits")[1].prefix or "six"

    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Moons")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    DRAGQUEENMOD.night_suits = {prefix .. "_Moons",prefix .. "_Stars"}
    -- Add Mothers
  end

  -- Minty's Silly Little Mod
  if next(SMODS.find_mod("MintysSillyMod")) then
    local prefix = SMODS.find_mod("MintysSillyMod")[1].prefix or "minty"

    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_3s")
    DRAGQUEENMOD.treat_suits = {prefix .. "_3s"}
    -- Add Mother
  end

  -- Magic: The Jokering
  if next(SMODS.find_mod("magic_the_jokering")) then
    local prefix = SMODS.find_mod("magic_the_jokering")[1].prefix or "mtg"

    DRAGQUEENMOD.magic_suits = {prefix .. "_Clovers", prefix .. "_Suitless"}
    -- Add Mothers
  end

  -- Ink And Color
  if next(SMODS.find_mod("InkAndColor")) then
    local prefix = SMODS.find_mod("InkAndColor")[1].prefix or "ink"

    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Inks")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Colors")
    DRAGQUEENMOD.stained_suits = {prefix .. "_Inks", prefix .. "_Colors"}
    -- Add Mothers
  end

  -- Pokermon
  -- Foresight compatibility

  -- UnStable
  -- Add Ranks

  -- Cryptid
  -- Add to their modifier deck

  -- Cardsleeves

  -- Partners

  -- More Fluff
  -- Add to 45-degree tarot cards

  -- Gemstones
  -- Add Gemstones to modifiers
end
