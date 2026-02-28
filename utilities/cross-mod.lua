------------------------------
-- Talisman compatibility 
------------------------------



DRAGQUEENMOD.to_big = to_big or function(n)
  return n
end



DRAGQUEENMOD.to_number = to_number or function(n)
  return n
end



------------------------------
-- Cross-mod rank sprite overrides
------------------------------



-- Adding our suits' cross-mod ranks (like Paperback Apostles) to their callable atlases
-- <br>May hopefully be removed if SMODS implements 'rank_map'
-- <br>Code thanks to UNIK, which took from Aikoyori
function DRAGQUEENMOD.sprite_info_override(_center, _front, card, orig_a, orig_p)
  _center = _center or card.config.center
  _front = _front or card.base
  --local hc = G.SETTINGS.colour_palettes[card.base] == "hc" and "_hc" or ""

  ------------------------------
  -- Apostles
  ------------------------------

  if _front.value == "paperback_Apostle" then
    if _front.suit == "dragqueen_Purses" then
      return G.ASSET_ATLAS["dragqueen_ranks_hc"], { x = 0, y = 1 }
    elseif _front.suit == "dragqueen_Pumps" then
      return G.ASSET_ATLAS["dragqueen_ranks_hc"], { x = 0, y = 2 }
    end

  --elseif etc for more custom ranks

  end

  return orig_a, orig_p
end



------------------------------
-- general cross-mod integration
------------------------------



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
  if SPECF.config then
    if SPECF.config.specflush == true then
      table.insert(DRAGQUEENMOD.spectrum_poker_hands, "Specflush")
      table.insert(DRAGQUEENMOD.spectrum_poker_hands, "Straight Specflush")
      table.insert(DRAGQUEENMOD.spectrum_poker_hands, "Specflush House")
      table.insert(DRAGQUEENMOD.spectrum_poker_hands, "Specflush Five")
    end
  end

  
-- Bunco
  if next(SMODS.find_mod("Bunco")) then
    local prefix = DRAGQUEENMOD.getprefix("Bunco", "bunc")

    -- Adds their suits to our definitions of light and dark and exotic and modded
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Halberds")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Fleurons")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Halberds")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Fleurons")
    DRAGQUEENMOD.suit_groups["exotic"] = { prefix .. "_Halberds", prefix .. "_Fleurons" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Halberds"] = "c_" .. prefix .. "_abyss"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Fleurons"] = "c_" .. prefix .. "_sky"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Halberds"] = "bunc_halberds"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Fleurons"] = "bunc_fleurons"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Halberds"] = { localization_entry = { "Tarot", "c_bunc_abyss" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Fleurons"] = { localization_entry = { "Tarot", "c_bunc_sky" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_BUNC_EXOTIC_SUIT = { "bunc_halberds", "bunc_halberds", "bunc_fleurons", "bunc_fleurons" }
  end

  -- Paperback
  if next(SMODS.find_mod("paperback")) then
    local prefix = DRAGQUEENMOD.getprefix("paperback", "paperback")

    -- Adds their suits to our definitions of light and dark and proud and modded
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crowns")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Crowns")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Stars")
    DRAGQUEENMOD.suit_groups["proud"] = { prefix .. "_Crowns", prefix .. "_Stars" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Crowns"] = "c_" .. prefix .. "_ace_of_swords"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Stars"] = "c_" .. prefix .. "_ace_of_pentacles"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Crowns"] = "paperback_crowns"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Stars"] = "paperback_stars"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Crowns"] = { localization_entry = { "paperback_minor_arcana", "c_paperback_ace_of_swords" }, consumable_category = { "misc", "dictionary", "k_paperback_minor_arcana" }, consumable_color = "paperback_minor_arcana" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Stars"] = { localization_entry = { "paperback_minor_arcana", "c_paperback_ace_of_pentacles" }, consumable_category = { "misc", "dictionary", "k_paperback_minor_arcana" }, consumable_color = "paperback_minor_arcana" }
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_PAPERBACK_PROUD_SUIT = { "paperback_crowns", "paperback_crowns", "paperback_stars", "paperback_stars" }
  end

  -- Six Suits
  if next(SMODS.find_mod("SixSuits")) then
    local prefix = SMODS.find_mod("SixSuits")[1].prefix or "six"

    -- Adds their suits to our definitions of light and dark and night
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Moons")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Stars")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Moons")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Stars")
    DRAGQUEENMOD.suit_groups["night"] = { prefix .. "_Moons",prefix .. "_Stars" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Moons"] = "c_" .. prefix .. "_moon_q"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Stars"] = "c_" .. prefix .. "_star_q"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Moons"] = "six_moons"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Stars"] = "six_stars"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Moons"] = { localization_entry = { "Tarot", "c_six_moon_q" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Stars"] = { localization_entry = { "Tarot", "c_six_star_q" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_SIX_NIGHT_SUIT = { "six_moons", "six_moons", "six_stars", "six_stars" }

  end

  -- Minty's Silly Little Mod
  if next(SMODS.find_mod("MintysSillyMod")) then
    local prefix = SMODS.find_mod("MintysSillyMod")[1].prefix or "minty"

    -- Adds their suits to our definitions of light and treat and modded
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_3s")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_3s")
    DRAGQUEENMOD.suit_groups["treat"] = { prefix .. "_3s" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_3s"] = "c_" .. prefix .. "_cat"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_3s"] = { localization_entry = { "Tarot", "c_minty_cat" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_color[prefix .. "_3s"] = "minty_3s"
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_MINTY_TREAT_SUIT = { "minty_3s" }
  end

  -- Magic: The Jokering
  if next(SMODS.find_mod("magic_the_jokering")) then
    local prefix = SMODS.find_mod("magic_the_jokering")[1].prefix or "mtg"

    -- Adds their suits to our definition of magic and modded
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Clovers")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Suitless")
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Clovers"] = "c_" .. prefix .. "_forest"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Suitless"] = "c_" .. prefix .. "_Wastes"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Clovers"] = { localization_entry = { "Tarot", "c_mtg_forest" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Suitless"] = { localization_entry = { "Tarot", "c_mtg_Wastes" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_color[prefix .. "_Clovers"] = "clover"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Suitless"] = "white"
    DRAGQUEENMOD.suit_groups["magic"] = { prefix .. "_Clovers", prefix .. "_Suitless" }
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_MTG_MAGIC_SUIT = { "clover", "clover", "white", "white" }
  end

  -- Ink And Color
  if next(SMODS.find_mod("InkAndColor")) then
    local prefix = SMODS.find_mod("InkAndColor")[1].prefix or "ink"

    -- Adds their suits to our definitions of light and dark and stained and modded
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Inks")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Colors")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Inks")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Colors")
    DRAGQUEENMOD.suit_groups["stained"] = { prefix .. "_Inks", prefix .. "_Colors" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Inks"] = "c_" .. prefix .. "_the_blob"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Colors"] = "c_" .. prefix .. "_the_paint"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Inks"] = { localization_entry = { "Tarot", "c_" .. prefix .. "_the_blob" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Colors"] = { localization_entry = { "Tarot", "c_" .. prefix .. "_the_paint" }, consumable_category = { "misc", "dictionary", "k_tarot" }, consumable_color = "tarot" }
    DRAGQUEENMOD.suits_to_color[prefix .. "_Inks"] = "ink_inks"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Colors"] = "ink_colors"
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_INK_STAINED_SUIT = { "ink_inks", "ink_inks", "ink_colors", "ink_colors" }
  end

  -- Madcap
  if next(SMODS.find_mod("rgmadcap")) then
    local prefix = SMODS.find_mod("rgmadcap")[1].prefix or "rgmc"

    -- Adds their suits to our definitions of light and dark and parallel and chaotic and modded
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_towers")
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_daggers")
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_voids")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_goblets")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_blooms")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_lanterns")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_towers")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_daggers")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_voids")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_goblets")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_blooms")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_lanterns")
    DRAGQUEENMOD.suit_groups["parallel"] = { prefix .. "_goblets", prefix .. "_towers", prefix .. "_blooms", prefix .. "_daggers" }
    DRAGQUEENMOD.suit_groups["chaotic"] = { prefix .. "_voids", prefix .. "_lanterns" }
    DRAGQUEENMOD.suits_to_color[prefix .. "_goblets"] = "rgmc_goblets"
    DRAGQUEENMOD.suits_to_color[prefix .. "_towers"] = "rgmc_towers"
    DRAGQUEENMOD.suits_to_color[prefix .. "_blooms"] = "rgmc_blooms"
    DRAGQUEENMOD.suits_to_color[prefix .. "_daggers"] = "rgmc_daggers"
    DRAGQUEENMOD.suits_to_color[prefix .. "_voids"] = "rgmc_voids"
    DRAGQUEENMOD.suits_to_color[prefix .. "_lanterns"] = "rgmc_lanterns"
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_RGMC_PARALLEL_SUIT = { "rgmc_goblets", "rgmc_goblets", "rgmc_towers", "rgmc_towers", "rgmc_blooms", "rgmc_blooms", "rgmc_daggers", "rgmc_daggers" }
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_RGMC_CHAOTIC_SUIT = { "rgmc_voids", "rgmc_voids", "rgmc_lanterns", "rgmc_lanterns" }
  end

  -- UNIKs
  if next(SMODS.find_mod("unik")) then
    local prefix = SMODS.find_mod("unik")[1].prefix or "unik"

    -- Adds their suits to our definitions of light and dark and parallel and tic-tac-toes
    table.insert(DRAGQUEENMOD.dark_suits, prefix .. "_Crosses")
    table.insert(DRAGQUEENMOD.light_suits, prefix .. "_Noughts")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Crosses")
    table.insert(DRAGQUEENMOD.modded_suits, prefix .. "_Noughts")
    DRAGQUEENMOD.suit_groups["tictactoe"] = { prefix .. "_Crosses", prefix .. "_Noughts" }
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Crosses"] = "c_" .. prefix .. "_denial"
    DRAGQUEENMOD.suits_to_consumable[prefix .. "_Noughts"] = "c_" .. prefix .. "_ring"
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Crosses"] = { localization_entry = { "Spectral", "c_unik_denial" }, consumable_category = { "misc", "dictionary", "k_spectral" }, consumable_color = "spectral" }
    DRAGQUEENMOD.suits_to_consumable_local_description[prefix .. "_Noughts"] = { localization_entry = { "Spectral", "c_unik_ring" }, consumable_category = { "misc", "dictionary", "k_spectral" }, consumable_color = "spectral" }
    DRAGQUEENMOD.suits_to_color[prefix .. "_Crosses"] = "unik_crosses"
    DRAGQUEENMOD.suits_to_color[prefix .. "_Noughts"] = "unik_noughts"
    DRAGQUEENMOD.sine_colors.DRAGQUEEN_UNIK_TICTACTOE_SUIT = { "unik_crosses", "unik_crosses", "unik_noughts", "unik_noughts" }
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
      for _, v in ipairs(DRAGQUEENMOD.dark_suits) do
        local suitfound = false
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
      for _, v in ipairs(DRAGQUEENMOD.light_suits) do
        local suitfound = false
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

    if modded_suits then
      for _, v in ipairs(DRAGQUEENMOD.modded_suits) do
        local suitfound = false
        for _, w in ipairs(modded_suits) do
          if w == v then
            suitfound = true
          end
        end
        if suitfound == false then
          table.insert(modded_suits, v)
        end
      end
    end

    -- Alternative implementation with their library depending on their version
    if next(SMODS.find_mod("MadLib")) then
      if MadLib then
        if MadLib.SuitTypes then
          if MadLib.SuitTypes.Light then
            for _, v in ipairs(DRAGQUEENMOD.light_suits) do
              local suitfound = false
              for _, w in ipairs(MadLib.SuitTypes.Light) do
                if w == v then
                  suitfound = true
                end
              end
              if suitfound == false then
                table.insert(MadLib.SuitTypes.Light, v)
              end
            end
          end

          if MadLib.SuitTypes.Dark then
            for _, v in ipairs(DRAGQUEENMOD.dark_suits) do
              local suitfound = false
              for _, w in ipairs(MadLib.SuitTypes.Dark) do
                if w == v then
                  suitfound = true
                end
              end
              if suitfound == false then
                table.insert(MadLib.SuitTypes.Dark, v)
              end
            end
          end
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
          UNIK.dark_suits = DRAGQUEENMOD.dark_suits
          UNIK.light_suits = DRAGQUEENMOD.light_suits
        end
      end
    end
  end

  if next(SMODS.find_mod("aikoyorisshenanigans")) then
    if AKYRS ~= nil then
      --hooking Aikoyori's Schenanigans' `AKYRS.should_hide_ui` function
      local dragqueen_hook_AKYRS_should_hide_UI = AKYRS.should_hide_ui
      
      -- Hooking this because we're doing weird stuff with `generate_card_ui` whilst not in a game session
      --<br>(generating a custom hover table for our Dictionary entries),
      -- <br>so their function searching for `G.GAME.akyrs_no_hints` crashes when `G.GAME` is not found
      ---@diagnostic disable-next-line: duplicate-set-field
      AKYRS.should_hide_ui = function()
        if not G.GAME then
          G.GAME = {}
        end
        return dragqueen_hook_AKYRS_should_hide_UI()
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

  -- Ink And Color
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
