-- Talisman compatibility
to_big = to_big or function(n)
  return n
end

to_number = to_number or function(n)
  return n
end


-- Searching for other mods for cross-mod content
-- Ones with different suits adding to their relevant suit definitions

-- Bunco
if next(SMODS.find_mod("Bunco")) then
  local prefix = SMODS.find_mod("Bunco")[1].prefix or "bunc"

  table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Halberds")
  table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Fleurons")
  DRAGQUEENMOD.exotic_suits = {prefix .. "_Halberds", prefix .. "_Fleurons"}
  -- Probably need to add Drag Queen suits to Bunco's definitions of light and dark 
  -- And potentially override their tooltip implementation
  -- Don't duplicate Glitter tag, edition
  -- Add consumer edition tags
  -- Add Mothers
  -- Add Stylophone audio
end

-- Paperback
if next(SMODS.find_mod("Paperback")) then
  local prefix = SMODS.find_mod("Paperback")[1].prefix or "paperback"

  table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crowns")
  table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
  DRAGQUEENMOD.proud_suits = {prefix .. "_Crowns", prefix .. "_Stars"}
  -- probably need to add Drag Queen suits to Paperback's definitions of light and dark suits
  -- And potentially override their tooltip implementation
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
  local prefix = SMODS.find_mod("magic_the_jokeringMintysSillyMod")[1].prefix or "mtg"

  DRAGQUEENMOD.magic_suits = {prefix .. "_Clovers", prefix .. "_Suitless"}
  -- Add Mothers
end

-- Ink And Color
if next(SMODS.find_mod("InkAndColor")) then
  local prefix = SMODS.find_mod("InkAndColor")[1].prefix or "ink"

  table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Inks")
  table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Colors")
  DRAGQUEENMOD.stained_suits = {prefix .. "_Inks", prefix .. "_Colors"}
  -- Add Mother
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



--- Whether to load stuff such as hands, planets and jokers related to Spectrums
--- This mod defers to everyone else
--- @return boolean
function DRAGQUEENMOD.should_load_spectrum_items()
  return not (
    next(SMODS.find_mod('Bunco'))
    or next(SMODS.find_mod("SixSuits"))
    or next(SMODS.find_mod("SpectrumFramework"))
  )
end