-- Talisman compatibility
DRAGQUEENMOD.to_big = to_big or function(n)
  return n
end

DRAGQUEENMOD.to_number = to_number or function(n)
  return n
end

-- Searching for other mods for cross-mod content and integration
function DRAGQUEENMOD.cross_mod_content_register()
  DRAGQUEENMOD.cross_mod_theirs_to_ours()
  DRAGQUEENMOD.load_cross_mod_ours_to_theirs = true
  DRAGQUEENMOD.cross_mod_dependent_and_duplicate_content()
end


-- We add other mods' definitions to our own,
-- and negate instantiating content already in other mods 
function DRAGQUEENMOD.cross_mod_theirs_to_ours()
  -- Spectrum Framework, required
  DRAGQUEENMOD.SpectrumFramework_spectrum_played_hook()
  if SPECF.config.specflush == true then
    table.insert(DRAGQUEENMOD.SPECTRUM_POKER_HANDS, "Specflush")
    table.insert(DRAGQUEENMOD.SPECTRUM_POKER_HANDS, "Straight Specflush")
    table.insert(DRAGQUEENMOD.SPECTRUM_POKER_HANDS, "Specflush House")
    table.insert(DRAGQUEENMOD.SPECTRUM_POKER_HANDS, "Specflush Five")
  end
  
-- Bunco
  if next(SMODS.find_mod("Bunco")) then
    local prefix = DRAGQUEENMOD.getprefix("Bunco", "bunc")

    -- Adds their suits to our definitions of light and dark and exotic
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Halberds")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Fleurons")
    DRAGQUEENMOD.exotic_suits = {prefix .. "_Halberds", prefix .. "_Fleurons"}
  end

  -- Paperback
  if next(SMODS.find_mod("paperback")) then
    local prefix = DRAGQUEENMOD.getprefix("paperback", "paperback")

    -- Adds their suits to our definitions of light and dark and proud
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crowns")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    DRAGQUEENMOD.proud_suits = {prefix .. "_Crowns", prefix .. "_Stars"}
  end

  -- Six Suits
  if next(SMODS.find_mod("SixSuits")) then
    local prefix = SMODS.find_mod("SixSuits")[1].prefix or "six"

    -- Adds their suits to our definitions of light and dark and night
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Moons")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    DRAGQUEENMOD.night_suits = {prefix .. "_Moons",prefix .. "_Stars"}

  end

  -- Minty's Silly Little Mod
  if next(SMODS.find_mod("MintysSillyMod")) then
    local prefix = SMODS.find_mod("MintysSillyMod")[1].prefix or "minty"

    -- Adds their suits to our definitions of light and dark and treat
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_3s")
    DRAGQUEENMOD.treat_suits = {prefix .. "_3s"}
  end

  -- Magic: The Jokering
  if next(SMODS.find_mod("magic_the_jokering")) then
    local prefix = SMODS.find_mod("magic_the_jokering")[1].prefix or "mtg"

    -- Adds their suits to our defintion of magic
    DRAGQUEENMOD.magic_suits = {prefix .. "_Clovers", prefix .. "_Suitless"}
  end

  -- Ink And Color
  if next(SMODS.find_mod("InkAndColor")) then
    local prefix = SMODS.find_mod("InkAndColor")[1].prefix or "ink"

    -- Adds their suits to our definitions of light and dark and stained
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Inks")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Colors")
    DRAGQUEENMOD.stained_suits = {prefix .. "_Inks", prefix .. "_Colors"}
    -- Add Mothers
  end

  -- Madcap
  if next(SMODS.find_mod("rgmadcap")) then
    local prefix = SMODS.find_mod("rgmadcap")[1].prefix or "rgmc"

    -- Adds their suits to our definitions of light and dark and parallel and chaotic
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_towers")
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_daggers")
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_voids")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_goblets")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_blooms")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_lanterns")
    DRAGQUEENMOD.parallel_suits = {prefix .. "_goblets", prefix .. "_towers", prefix .. "_blooms", prefix .. "_daggers"}
    DRAGQUEENMOD.chaotic_suits = {prefix .. "_voids", prefix .. "_lanterns"}
  end

  -- UNIKs
  if next(SMODS.find_mod("unik")) then
    local prefix = SMODS.find_mod("unik")[1].prefix or "unik"

    -- Adds their suits to our definitions of light and dark and parallel and tic-tac-toes
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crosses")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Noughts")
    DRAGQUEENMOD.tictactoe_suits = {prefix .. "_Crosses", prefix .. "_Noughts"}
  end
end

-- We add our mod's definitions to others and patch others' content; 
-- Run at the last possible second in our hooks.lua: dragqueen_hook_splash_screen
function DRAGQUEENMOD.cross_mod_ours_to_theirs()
  -- Bunco
  if next(SMODS.find_mod("Bunco")) then
    DRAGQUEENMOD.Bunco_joker_patch()
  end

  -- Paperback
  if next(SMODS.find_mod("paperback")) then
    -- If their definition of light and dark don't already reference our suits, they now do
    -- We have to find their definition relative to the player's mod install
    local paperback_path = tostring(SMODS.Mods["paperback"].path)
    local paperback_cross_mod_path = paperback_path .. "utilities/cross-mod.lua"
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
  end

  -- Madcap
  if next(SMODS.find_mod("rgmadcap")) then
    -- We add all of our dark and light suits we know of to their definition
    if dark_suits then
      local suitfound = false
      for _, v in ipairs(DRAGQUEENMOD.dark_suits) do
        for _, w in ipairs(dark_suits) do
          if w == v then
            suitfound = true
          end
        end
        if suitfound == false then
          table.insert(dark_suits, v)
        end
      end
    end

    if light_suits then
      local suitfound = false
      for _, v in ipairs(DRAGQUEENMOD.light_suits) do
        for _, w in ipairs(light_suits) do
          if w == v then
            suitfound = true
          end
        end
        if suitfound == false then
          table.insert(light_suits, v)
        end
      end
    end
  end

  -- UNIKs
  if next(SMODS.find_mod("unik")) then
    -- If their definition of light and dark don't already reference our suits, they now do
    -- We have to find their definition relative to the player's mod install
    local unik_path = tostring(SMODS.Mods["unik"].path)
    local unik_main_path = unik_path .. "unik.lua"
    local unik_main_file = assert(io.open(unik_main_path,"r"), "Couldn't understand Unik path")
    -- If there's no mention of the our mod, then they're probably not implementing us
    if unik_main_file then
      local unik_main = unik_main_file:read("*a")
      if not string.find(unik_main, "dragqueen") then
        if UNIK then
          UNIK.is_suit_type = DRAGQUEENMOD.is_suit
          UNIK.suit_tooltip = DRAGQUEENMOD.suit_tooltip
        end
      end
    end
  end

end

-- register content that is dependent on other mods
-- remove content that is already implemented in another mod
function DRAGQUEENMOD.cross_mod_dependent_and_duplicate_content()
  -- Bunco
    -- Add consumer edition tags
    -- Add Mothers
    -- Add Stylophone audio
    -- Don't duplicate Glitter tag, edition

  -- Paperback
    -- Add paperclips to modifiers
    -- Add their ranks
    -- Add Mothers, which also count as Apostles
  
  -- Six Suits
    -- Add Mothers
  
  -- Minty's Silly Little Mod
    -- Add Mother

  -- Magic: The Jokering
    -- Add Mothers

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