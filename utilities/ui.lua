-- Create config UI
-- In create_toggle could make active_colour something cute
---@diagnostic disable-next-line: duplicate-set-field
SMODS.current_mod.config_tab = function ()
  return {
    n = G.UIT.ROOT,
    config = {align = "cm", padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK},
    nodes = {
      {
        n = G.UIT.R,
        config = { align = "cm", minh = 1 },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = localize('dragqueen_ui_requires_restart'),
              colour = G.C.RED,
              scale = 0.5,
              shadow = true
            }
          }
        }
      },
      {
        n = G.UIT.R,
        config = { align = "cm"},
        nodes = {
          {
            n = G.UIT.C,
            config = {align = "cl"},
            nodes = {
              create_toggle {
                label = localize("dragqueen_ui_jokers_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "jokers_enabled"
              },
              create_toggle {
                label = localize("dragqueen_ui_decks_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "decks_enabled"
              },
              create_toggle {
                label = localize("dragqueen_ui_blinds_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "blinds_enabled"
              }
            }
          },
          {
            n = G.UIT.C,
            config = {align = "cr"},
            nodes = {
              create_toggle {
                label = localize("dragqueen_UI_skins_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "skins_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_UI_vanilla_reworks_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "vanilla_reworks_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_UI_cross_mod_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "cross_mod_enabled",
                w = 4.5
              }
            }
          }
        }
      }
    }
  }
end


-- Create Credits tab in our mod UI

-- Create collection entries for Kisses if we have multiple types, or just stick them in stickers



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

  -- every type but light and dark has a clear-cut answer
  -- "plain" and "accessory" don't have a mod prefix bc they're only referenced in our mod
  local suit_types_to_mod_prefixes = {
    ["plain"] = "",
    ["accessory"] = "",
    ["exotic"] = "bunc_",
    ["proud"] = "paperback_",
    ["night"] = "six_",
    ["treat"] = "minty_",
    ["magic"] = "mtg_",
    ["stained"] = "ink_"
  }

  -- convention in our localization file for referencing other mods
  -- ex. dragqueen_bunco_exotic_suits
  for modtype, modprefix in pairs(suit_types_to_mod_prefixes) do
    if modtype == type then
      key = key .. modprefix .. type .. "_suits"
    end
  end

  -- if type is light or dark:
  -- if the only suits in play (in G.GAME) are plain (Clubs, Hearts, Spades, Diamonds)
  -- then only show G.localization.descriptions.dragqueen_dark_suits_vanilla
  -- or etc light_suits_vanilla
  -- HOWEVER: if there are other suits in play then we gotta check each mod
  -- if *one* of the non-plain suits are in play, consider all cross mod suits in play
  -- see the en-us.lua notes
  if type == "dark" or "light" then
    local suits = type == "light" and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits
    -- if playing with only plain suits, only display the vanilla suits; ex. dragqueen_vanilla_dark_suits
    if not G.GAME.NonPlain then
      key = key .. "vanilla_" .. type .. "_suits"
      
    -- Since any modded suits are in play, we consider all of them in play
    -- Let's dynamically add them all to localization, first figuring out what mods even there are
    else
      local mod_names = {
        "Bunco",
        "Paperback",
        "SixSuits",
        "MintysSillyMod",
        "magic_the_jokering",
        "InkAndColor"
      }
      local mods_in_play = {}

      -- Let's first figure out what mods are even installed
      for _, modname in ipairs(mod_names) do
        if next(SMODS.find_mod(modname)) then
          table.insert(mods_in_play, modname)
        end
      end

      -- Referencing G.localization.grammar for conjunction order
      -- Starting out with adding the vanilla and drag queen suits
      -- Each item in messageparts is a table of text tables
      local messageparts = {
        DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text,
        DRAGQUEENMOD.easydescriptionlocalize("Suit","dragqueen_vanilla_plus_" .. type .. "_suits").text,
      }
      if #suits == 3 then
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text)
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Suit", "dragqueen_accessory_" .. type .. "_suits").text)
      else
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3"))
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Suit", "dragqueen_accessory_" .. type .. "_suits").text)

        -- Now, if there's any modded suits we add those to messageparts
        for _, modname in ipairs(mods_in_play) do
          -- i.e. last modded suit to be added
          if DRAGQUEENMOD.indexof(mods_in_play, modname) == #(suits - 3) then
            table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text)
            table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Suit", "dragqueen_" .. DRAGQUEENMOD.guessedprefix(modname) .. "_" .. type .. "_suits").text)
          -- i.e. there's more modded suits after this one
          else
            table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text)
            table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Suit", "dragqueen_" .. DRAGQUEENMOD.guessedprefix(modname) .. "_" .. type .. "_suits").text)
          end
        end
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction5").text)
      end

      -- Now we have all the messageparts, let's extract the strings from the text tables
      local messagestrings = {}
      for _, texttable in ipairs(mods_in_play) do
        for _, textstring in ipairs(texttable) do
          table.insert(messagestrings, textstring)
        end
      end
      
      -- Now we take all those strings and put them into "lines" of text that you'd see on the screen. We don't want those to be overly long
      local line = ""
      local text = {}
      for _, textstring in ipairs(messagestrings) do
        -- Line has room, we can keep typing
        if line < 30 then
          line = line .. textstring
        -- Typewriter goes "ding!", next line
        else
          text[#text+1] = line
          line = ""
        end
      end

      -- Put the last line in
      if #line > 0 then
        text[#text + 1] = line
      end

      -- We also gotta get all the "colours" for the suits
      for i = 1, #suits do
        local suit = suits [i]
        colours[#colours+1] = G.C.SUITS[suit] or G.C.IMPORTANT
      end

      -- For the grand finale we take our table of text and give it back to localization
      -- I might have to do something with .text_parsed format and loc_parse_string? I hope giving it the same text is okay
      if type == "dark" then
        G.localization.descriptions.Suit.dragqueen_dark_suits_in_play.text = text
        G.localization.descriptions.Suit.dragqueen_dark_suits_in_play.text_parsed = text
        key = "dragqueen_dark_suits_in_play"
      else
        G.localization.descriptions.Suit.dragqueen_light_suits_in_play.text = text
        G.localization.descriptions.Suit.dragqueen_light_suits_in_play.text_parsed = text
        key = "dragqueen_light_suits_in_play"
      end
    end
  end


  return {
    -- Balatro's functions/common_events.lua:function generate_card_ui() builds a full_UI_table.name
    -- which is parsed with Balatro's functions/misc_functions.lua:function localize(args, misc_cat)
    -- This return gets sent to localize() with type "descriptions", and using the suit and key the text table is given to loc_target

    -- "Colours" here comes from Balatro's own Canadian code
    -- It might be needed to pass in the ex. "{V:1}Spades{}" format?
    -- If that's the case I'll need to reformat the above from the {C:Dragqueen_Purses}Purses{}" format
    type = "descriptions",
    set = "Suit",
    key = key,
    vars = {
      colours = colours
    }
  }
end


-- Kiss tooltip, if we only have one then add to stickers
-- But if there's different types then can add to its own 


-- Anything else, like for a UI to select a particular Drag Queen joker