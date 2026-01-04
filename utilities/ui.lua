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
  -- HOWEVER: if there are other suits in play (or we're looking at a card from Collection) then we gotta check each mod
  -- if *one* of the non-plain suits are in play, consider all cross mod suits in play
  -- see the en-us.lua notes
  if type == "dark" or "light" then
    local suits = type == "light" and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits
    -- if in game and playing with only plain suits, only display the vanilla suits; ex. dragqueen_vanilla_dark_suits
    if G.Game and not G.GAME.NonPlain then
      key = key .. "vanilla_" .. type .. "_suits"
      
    -- Since any modded suits are in play, we consider all of them in play
    -- Let's dynamically add them all to localization, first figuring out what mods even there are
    else
      key = key .. type .. "_suits_in_play"
      local mod_names = {
        "Bunco",
        "paperback",
        "MintysSillyMod",
        "SixSuits",
        "InkAndColor"
      }
      local mods_in_play = false

      -- Let's first figure out if other modded suits are relevant
      for _, modname in ipairs(mod_names) do
        if next(SMODS.find_mod(modname)) then
          mods_in_play = true
        end
      end

      -- Referencing G.localization.grammar for conjunction order
      -- Starting out with adding the vanilla and drag queen suits
      -- Each item in messageparts is a table of text tables
      local messageparts = {}
      table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text)
      table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other","dragqueen_vanilla_plus_" .. type .. "_suits").text)
      if not mods_in_play then
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text)
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other", "dragqueen_accessory_" .. type .. "_suits").text)
      else
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text)
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other", "dragqueen_accessory_" .. type .. "_suits").text)

        -- Now, if there's any modded suits we add those to messageparts
        for _, modname in ipairs(mod_names) do
          -- First we check to make sure that mod does have the category of light and dark suits (ex. MintysSillyMod only has a light suit)
          if next(SMODS.find_mod(modname)) then
            if pcall(DRAGQUEENMOD.easydescriptionlocalize, "Other", "dragqueen_" .. DRAGQUEENMOD.getprefix(modname) .. "_" .. type .. "_suits") then
                table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text)
                table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other", "dragqueen_" .. DRAGQUEENMOD.getprefix(modname) .. "_" .. type .. "_suits").text)
            end
          end
        end
        table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction5").text)
      end

      -- Then we have to insert conj4 at the correct position; third to last. In en-us, this is ", and "
      messageparts[(#messageparts) - 2] = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text

      -- Now we have all the messageparts text tables, let's extract the strings into a simpler table of strings
      local messagestrings = {}
      for _, texttable in ipairs(messageparts) do
        for _, textstring in ipairs(texttable) do
          table.insert(messagestrings, textstring)
          print(textstring)
        end
      end
      
      -- Now we take all those strings and put them into "lines" of text that you'd see on the screen. We don't want those to be overly long
      local line = ""
      local text = {}
      local textparsed = {}
      local conj3 = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text[1]
      local conj4 = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text[1]
      for _, textstring in ipairs(messagestrings) do
        -- Line has room, we can keep typing

        if (string.len(line) < 35) or (textstring == conj3) or (textstring == conj4) then
          line = line .. textstring
        -- Typewriter goes "ding!", next line
        else
          table.insert(text, line)
          line = textstring
        end
      end

      -- Put the last line in
      if string.len(line) > 0 then
        table.insert(text, line)
      end

      -- We also gotta get all the "colours" for the suits
      for i = 1, #suits do
        local suit = suits [i]
        colours[#colours+1] = G.C.SUITS[suit] or G.C.IMPORTANT
      end

      -- We let Balatro's misc_functions.lua:loc_parse_string() handle the text
      for _, v in ipairs(text) do
        textparsed[#textparsed+1] = loc_parse_string(v)
      end

      -- For the grand finale we take our table of text and give it back to localization
      G.localization.descriptions.Other[key].text = text
      G.localization.descriptions.Other[key].text_parsed = textparsed

    end
  end


  return {
    -- Balatro's functions/common_events.lua:function generate_card_ui() builds a full_UI_table.name
    -- which is parsed with Balatro's functions/misc_functions.lua:function localize(args, misc_cat)
    -- This return gets sent to localize() with type "Other", and using the suit and key the text table is given to loc_target

    -- "Colours" here comes from Balatro's own Canadian code
    set = "Other",
    key = key,
    vars = {
      colours = colours
    }
  }
end


-- Kiss tooltip, if we only have one then add to stickers
-- But if there's different types then can add to its own 


-- Anything else, like for a UI to select a particular Drag Queen joker