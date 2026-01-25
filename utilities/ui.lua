------------------------------
-- Mod tabs and displayed info
------------------------------



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
              text = localize("dragqueen_ui_requires_restart"),
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
                ref_value = "jokers_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_ui_decks_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "decks_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_ui_blinds_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "blinds_enabled",
                w = 4.5
              }
            }
          },
          {
            n = G.UIT.C,
            config = {align = "cr"},
            nodes = {
              create_toggle {
                label = localize("dragqueen_ui_skins_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "skins_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_ui_vanilla_reworks_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "vanilla_reworks_enabled",
                w = 4.5
              },
              create_toggle {
                label = localize("dragqueen_ui_cross_mod_enabled"),
                ref_table = DRAGQUEENMOD.config,
                ref_value = "cross_mod_enabled",
                w = 4.5
              }
            }
          }
        }
      },
      {
        n = G.UIT.R,
        config = { align = "cm", minh = 1 },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = localize("dragqueen_ui_does_not_require_restart"),
              colour = G.C.GREY,
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
          create_toggle {
            label = localize("dragqueen_ui_swears_enabled"),
            ref_table = DRAGQUEENMOD.config,
            ref_value = "swears_enabled",
            w = 4.5
          },
          -- If there's more than 1 "Does Not REquire Restart" option, sort into two below node columns
          -- {
          --   n = G.UIT.C,
          --   config = {align = "cl"},
          --   nodes = {
          --   }
          -- },
          -- {
          --   n = G.UIT.C,
          --   config = {align = "cr"},
          --   nodes = {
          --   }
          -- }
        }
      },
    }
  }
end



-- Create Credits tab in our mod UI

-- Create collection entries for Kisses if we have multiple types, or just stick them in stickers



------------------------------
-- Tooltips
------------------------------



-- Returns a table that can be inserted into info_queue to show all suits of the provided type
--- @param tooltiptype
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
--- | "parallel"
--- | "chaotic"
--- | "tictactoe"
--- @return table
function DRAGQUEENMOD.suit_tooltip(tooltiptype)
  local key = "dragqueen_"
  local colours = {}


  -- convention in our localization file for referencing other mods
  -- ex. dragqueen_bunco_exotic_suits
  for modtype, modprefix in pairs(DRAGQUEENMOD.suit_types_to_mod_prefixes) do
    if modtype == tooltiptype then
      key = key .. modprefix .. tooltiptype .. "_suits"
    end
  end

  -- if type is light or dark:
  if tooltiptype == "dark" or "light" then
    local usingnonplain = G.GAME.NonPlain

    if usingnonplain == false then
      key = key .. tooltiptype .. "_suits_in_play_plain"
    else
      key = key .. tooltiptype .. "_suits_in_play_nonplain"
    end
    
    -- Check if the dynamic tooltips have already been generated this session
    if next(DRAGQUEENMOD.easydescriptionlocalize("Other", key).text) == nil then
      ---@diagnostic disable-next-line: param-type-mismatch
      colours = DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark(tooltiptype, key, usingnonplain)
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



-- Build the tooltip for light and dark suits
--- @param tooltiptype "dark" | "light"
--- @param usingnonplain boolean
--- @param key string
--- @return table
function DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark(tooltiptype, key, usingnonplain)
  -- if you're in a run and a spectrum or specflush hand has not been played, only show vanilla suits
  -- HOWEVER: if spectrum hands have been played (or if we're just looking at a tooltip from a card from Collection) then we show the full version of the tooltip
  -- see the en-us.lua notes on Grammar and conjunctions
  -- Each item in messageparts is either table of text tables, or if a vanilla suit is referenced just a string
  local suits = tooltiptype == "light" and DRAGQUEENMOD.light_suits or DRAGQUEENMOD.dark_suits
  local colours = {}
  local messageparts = {}
  local spadesstring = "{C:spades}" .. DRAGQUEENMOD.easymisclocalize("suits_plural", "Spades") .. "{}"
  local clubsstring = "{C:clubs}" .. DRAGQUEENMOD.easymisclocalize("suits_plural", "Clubs") .. "{}"
  local heartsstring = "{C:hearts}" .. DRAGQUEENMOD.easymisclocalize("suits_plural", "Hearts") .. "{}"
  local diamondsstring = "{C:diamonds}" .. DRAGQUEENMOD.easymisclocalize("suits_plural", "Diamonds") .. "{}"
  
  

  if G.GAME.NonPlain == false then
    messageparts = DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark_for_plain(tooltiptype, messageparts, spadesstring, clubsstring, heartsstring, diamondsstring)
  else
    messageparts = DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark_for_nonplain(tooltiptype, messageparts, spadesstring, clubsstring, heartsstring, diamondsstring)
  end

  
  -- Now we have all the messageparts text tables, let's extract the strings into a simpler table of strings
  local messagestrings = {}
  for _, texttableorstring in ipairs(messageparts) do
    if type(texttableorstring) == "table" then
      for _, textstring in ipairs(texttableorstring) do
        table.insert(messagestrings, textstring)
      end
    elseif type(texttableorstring) == "string" then
      table.insert(messagestrings, texttableorstring)
    end
  end

  -- Now we take all those strings and put them into "lines" of text that you'd see on the screen. We don't want those to be overly long
  local line = ""
  local text = {}
  local textparsed = {}
  local conj3 = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text[1]
  local conj4 = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text[1]
  for _, textstring in ipairs(messagestrings) do
    -- If line has room, we can keep typing
    -- we determine the length without the style codes (like {C:Clubs}) because those are invisible
    if (string.len(DRAGQUEENMOD.remove_style_modifier_codes(line)) < 15) or (textstring == conj3) or (textstring == conj4) then
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

  return colours
end



-- Build the light and dark suits for NonPlain == false 
--- @param tooltiptype "dark" | "light"
--- @param messageparts table
--- @param spadesstring string
--- @param clubsstring string
--- @param heartsstring string
--- @param diamondsstring string
--- @return table
function DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark_for_plain(tooltiptype, messageparts, spadesstring, clubsstring, heartsstring, diamondsstring)
  if tooltiptype == "dark" then
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text)
    table.insert(messageparts, spadesstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4short").text)
    table.insert(messageparts, clubsstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction5").text)
  else
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text)
    table.insert(messageparts, heartsstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4short").text)
    table.insert(messageparts, diamondsstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction5").text)
  end

  return(messageparts)
end



-- Build the light and dark suits for NonPlain == false 
-- We check each mod so that we can display their light and dark modded suits
-- if *one* of the non-plain suits are in play, consider all cross mod suits in play
--- @param tooltiptype "dark" | "light"
--- @param messageparts table
--- @param spadesstring string
--- @param clubsstring string
--- @param heartsstring string
--- @param diamondsstring string
--- @return table
function DRAGQUEENMOD.suit_tooltip_build_for_light_or_dark_for_nonplain(tooltiptype, messageparts, spadesstring, clubsstring, heartsstring, diamondsstring)
  
  local mod_names = {
    "Bunco",
    "paperback",
    "MintysSillyMod",
    "SixSuits",
    "InkAndColor",
    "rgmadcap",
    "unik"
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
  if tooltiptype == "dark" then
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text)
    table.insert(messageparts, spadesstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction2").text)
    table.insert(messageparts, clubsstring)
  else
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction1").text)
    table.insert(messageparts, heartsstring)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction2").text)
    table.insert(messageparts, diamondsstring)
  end

  -- Then we add our mod's suit
  if not mods_in_play then
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other", "dragqueen_accessory_" .. tooltiptype .. "_suits").text)
  else
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text)
    table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Other", "dragqueen_accessory_" .. tooltiptype .. "_suits").text)
  end

  if mods_in_play then
    -- Now, if there's any modded suits we add those to messageparts
    for _, modname in ipairs(mod_names) do
      -- First we check to make sure that mod does have the category of light and dark suits (ex. MintysSillyMod only has a light suit)
      if next(SMODS.find_mod(modname)) then
        local modsuits = "dragqueen_" .. DRAGQUEENMOD.getprefix(modname) .. "_" .. tooltiptype .. "_suits"
        if pcall(DRAGQUEENMOD.easydescriptionlocalize, "Other", modsuits) then
          for _, v in ipairs(DRAGQUEENMOD.easydescriptionlocalize("Other", modsuits).text) do
            table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction3").text)
            table.insert(messageparts, {v})
          end
        end
      end
    end
  end
  table.insert(messageparts, DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction5").text)

  -- Then we have to insert conj4 at the correct position; third to last. In en-us, this is ", and "
  messageparts[(#messageparts) - 2] = DRAGQUEENMOD.easydescriptionlocalize("Grammar", "dragqueen_suit_conjunction4").text

  return(messageparts)
end



------------------------------
-- Badges
------------------------------



-- Puts a badge under a suited card indicating if it is a Light Suit, a Dark Suit, or both
function DRAGQUEENMOD.card_suit_badge(obj, badges)
  if obj then
    if obj.is_suit ~= nil and obj.key ~= nil and obj.base_card.config ~= nil then

      local dark_or_light_suittext, dark_or_light_badgecolor, dark_or_light_textcolor = DRAGQUEENMOD.get_dark_or_light_suit_badge(obj)
      if dark_or_light_suittext and dark_or_light_badgecolor and dark_or_light_textcolor then
        badges[#badges + 1] = DRAGQUEENMOD.get_badge_template(dark_or_light_suittext, dark_or_light_badgecolor, dark_or_light_textcolor)
      end

      local suit_type_suittext, suit_type_badgecolor, suit_type_textcolor = DRAGQUEENMOD.get_suit_type_badge(obj)
      if suit_type_suittext and suit_type_badgecolor and suit_type_textcolor then
        badges[#badges + 1] = DRAGQUEENMOD.get_badge_template(suit_type_suittext, suit_type_badgecolor, suit_type_textcolor)
      end
    end
  end
end



function DRAGQUEENMOD.get_dark_or_light_suit_badge(obj, givenbadgecolor, giventextcolor)
  local suitkey = nil
  local suittext = nil
  local badgecolor = givenbadgecolor or G.C.GREEN
  local textcolor = giventextcolor or G.C.WHITE
  local isdark = false
  local islight = false
  local isbothdarkandlight = false


  for _, v in pairs(DRAGQUEENMOD.dark_suits) do
    if obj.key == v then
      isdark = true
    end
  end
  for _, v in pairs(DRAGQUEENMOD.light_suits) do
    if obj.key == v then
      islight = true
    end
  end

  local islucky = false
  if obj.base_card.config.center.key == "m_wild" then islucky = true end
  if islucky == true then isbothdarkandlight = true end

  -- Patch target for DRAGQUEENMOD.get_dark_or_light_suit_badge if you want more conditions to be considered both dark and light

  if (isdark == true and islight == true) or isbothdarkandlight == true then
    suitkey = "dragqueen_card_badge_dark_and_light_suit"
    badgecolor = G.C.DRAGQUEEN_DARK_AND_LIGHT_SUIT
  elseif isdark == true then
    suitkey = "dragqueen_card_badge_dark_suit"
    badgecolor = G.C.DRAGQUEEN_DARK_SUIT
  elseif islight == true then
    suitkey = "dragqueen_card_badge_light_suit"
    badgecolor = G.C.DRAGQUEEN_LIGHT_SUIT
  end

  -- suitkey value check
  if suitkey ~= nil then
    suittext = DRAGQUEENMOD.easymisclocalize("dictionary", suitkey)
    assert(type(suittext) == "string", "issue pulling " .. suitkey .. " string in 'Jimbo in Drag' mod")
  else
    error("suitkey value in DRAGQUEENMOD.get_dark_or_light_suit_badge is nonsensical")
  end

  return suittext, badgecolor, textcolor
end



function DRAGQUEENMOD.get_suit_type_badge(obj, giventextcolor)
  local obj_suit_to_eval = obj.base_card.config.card.suit
  local obj_suit_category = nil

  -- obj.base_card.config.card.suit
  for suitcategory, suitsets in pairs(DRAGQUEENMOD.suit_groups) do
    for _, individual_suit in ipairs(suitsets) do
      if obj_suit_to_eval == individual_suit then
        obj_suit_category = suitcategory
      end
    end
  end

  if obj_suit_category ~= nil then
    local prefix = DRAGQUEENMOD.suit_types_to_mod_prefixes[obj_suit_category]
    local suitkey = "dragqueen_card_badge_" .. prefix .. obj_suit_category .. "_suit"
    local badgecolor = G.C["DRAGQUEEN_" .. string.upper(prefix) .. string.upper(obj_suit_category) .. "_SUIT"]
    local textcolor = giventextcolor or G.C.WHITE

    -- suitkey value check
    if suitkey ~= nil then
      local suittext = DRAGQUEENMOD.easymisclocalize("dictionary", suitkey)
      assert(type(suittext) == "string", "issue pulling " .. suitkey .. " string in 'Jimbo in Drag' mod")

      return suittext, badgecolor, textcolor
    else
      error("suitkey value in DRAGQUEENMOD.get_suit_type_badge is nonsensical")
    end
  end
end



function DRAGQUEENMOD.get_badge_template(badgetext, badgecolor, textcolor)
  local size = 0.9
  local font = G.LANG.font
  local scale_fac = 1
  local max_text_width = 2 - 2*0.05 - 4*0.03*size - 2*0.03
  local calced_text_width = 0
  for _, c in utf8.chars(badgetext) do
    -- pulled directly from SMODS code
    ---@diagnostic disable-next-line: undefined-field
    local tx = font.FONT:getWidth(c)*(0.33*size)*G.TILESCALE*font.FONTSCALE + 2.7*1*G.TILESCALE*font.FONTSCALE
    calced_text_width = calced_text_width + tx/(G.TILESIZE*G.TILESCALE)
  end

  local badgetobuild = {
    n = G.UIT.R, config = {align = "cm"},
    nodes = {
      {
        n = G.UIT.R,
        config = {
          align = "cm", r = 0.1, minw = 2, minh = 0.36, emboss = 0.05, padding = 0.03*size,
          -- Overall badge color
          colour = badgecolor or G.C.GREEN,
        },
        nodes = {
          -- Spacer
          { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
          {
            n = G.UIT.O,
            config = {
              -- The actual text
              object = DynaText(
                {
                  string = badgetext,
                  colours = { textcolor },
                  silent = true,
                  float = true,
                  shadow = true,
                  offset_y = -0.05,
                  spacing = 1 * scale_fac,
                  scale = 0.33 * size * scale_fac,
                  marquee = calced_text_width > max_text_width,
                  maxw = max_text_width
                }
              )
            }
          },
          -- Spacer
          { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
        }
      }
    }
  }

  return badgetobuild
end



-- Kiss tooltip, if we only have one then add to stickers
-- But if there's different types then can add to its own 


-- Anything else, like for a UI to select a particular Drag Queen joker
