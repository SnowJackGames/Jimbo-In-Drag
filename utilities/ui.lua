------------------------------
-- Mod tabs and displayed info
------------------------------



-- Create config UI
-- In create_toggle could make active_colour something cute
---@diagnostic disable-next-line: duplicate-set-field
SMODS.current_mod.config_tab = function ()
  return {
    n = G.UIT.ROOT,
    config = {
      align = "tm",
      padding = 0.05,
      emboss = 0.05,
      r = 0.1,
      colour = G.C.BLACK,
      minh = 6,
    },
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



-- Take entries in `DRAGQUEENMOD.dictionary` and localize and alphabetize the entries
function DRAGQUEENMOD.build_dictionary()
  local built_dictionary = {}

  -- Get all the entries, and localize their values
  for _, word in ipairs(DRAGQUEENMOD.dictionary) do
    assert(type(word.entry) == "string", "word.entry in DRAGQUEENMOD.dictionary is not string")
    if word.set ~= nil then
      assert(type(word.set) == "string", "word.set in DRAGQUEENMOD.dictionary is not string")
    end
    if word.key ~= nil then
      assert(type(word.key) == "string", "word.key in DRAGQUEENMOD.dictionary is not string")
    end

    local set = word.set or "Other"
    local key = word.key or ("dragqueen_dictionary_" .. word.entry)
    local localized_entry = DRAGQUEENMOD.easydescriptionlocalize(set, key)
    localized_entry.set = set
    localized_entry.key = key

    -- Associate tooltips if present
    if word.extra_tooltips ~= nil then
      local associated_tooltips = {}

      for _, tooltip in ipairs(word.extra_tooltips) do
        if (tooltip.category and tooltip.set and tooltip.key) then
          assert(type(tooltip.category) == "string", "tooltip.category in DRAGQUEENMOD.dictionary is not string")
          assert(type(tooltip.set) == "string", "tooltip.set in DRAGQUEENMOD.dictionary is not string")
          assert(type(tooltip.key) == "string", "tooltip.key in DRAGQUEENMOD.dictionary is not string")

          local localized_tooltip = nil
          if tooltip.category == "descriptions" then
            localized_tooltip = DRAGQUEENMOD.easydescriptionlocalize(tooltip.set, tooltip.key)
          elseif tooltip.category == "misc" then
            localized_tooltip = DRAGQUEENMOD.easymisclocalize(tooltip.set, tooltip.key)
          else
            error("tooltip.category \"" .. tooltip.category .. "\" associated with \"" .. word.entry .. "\" given to DRAGQUEENMOD.dictionary must be \"descriptions\" or \"misc\"")
          end

          local passed_config = tooltip.config or nil

          if passed_config ~= nil then
            localized_tooltip.config = passed_config
          end

          localized_tooltip.set = tooltip.set
          localized_tooltip.key = tooltip.key

          -- Remember, localized_tooltip is either a string or a table of strings 
          associated_tooltips[#associated_tooltips+1] = localized_tooltip
        elseif (tooltip.tooltip_from_function) then
          associated_tooltips[#associated_tooltips+1] = tooltip
        end
      end

      localized_entry.extra_tooltips = associated_tooltips
    end

    built_dictionary[word.entry] = localized_entry
  end

  -- Entries have:
  -- - `name` table
  -- - `text` table
  -- - `name_parsed` table
  -- - `text_parsed` table
  -- - `set` string
  -- - `key` string
  --
  -- Potentially, a `extra_tooltips` table, each item within having similar variables to the listed above
  DRAGQUEENMOD.built_dictionary = built_dictionary
end



local function dictionary_entry(word)
  return type(word) == "table" and word.name or word
end



local function get_dictionary_entry(word_name)
  return DRAGQUEENMOD.built_dictionary[dictionary_entry(word_name)]
end



-- In English, `DRAGQUEENMOD.dictionary[accessorize]` has the localized name `Accessorize`,
-- <br>but other languages will be different
-- <br>Thusly, word variable `accessorize` is associated with localized name "Accessorize" or "Personalizar" etc
-- <br>We want words to be sorted by the present language
function DRAGQUEENMOD.locally_sort_built_dictionary()
  -- Ex. "Accessorize" or "Personalizar"
  local alphabetized_localized_name = {}
  -- Ex. "Personalizar" = accessorize
  local localized_name_to_word_variable = {}
  local word_variables_sorted_locally = {}

  -- Get the local names, and associate them with their word variable
  for word_variable, word_data in pairs(DRAGQUEENMOD.built_dictionary) do
    table.insert(alphabetized_localized_name, word_data.name)
    localized_name_to_word_variable[word_data.name] = word_variable
  end

  -- Create local assortment
  table.sort(alphabetized_localized_name, function(a,b) return a:lower() < b:lower() end)

  -- Build the word variables to be sorted locally
  for _, word_variable in pairs(localized_name_to_word_variable) do
    word_variables_sorted_locally[#word_variables_sorted_locally+1] = word_variable
  end

  DRAGQUEENMOD.word_variables_sorted_locally = word_variables_sorted_locally
  return word_variables_sorted_locally
end


-- Creates a box holding a grid of dictionary entries, and an option cycle
local dictionary_tab_create_grid = function()
  local page = G.dictionary_grid_page or 1
  local rows, cols = 4, 1
  local word_variable_list = DRAGQUEENMOD.word_variables_sorted_locally
  local row_nodes = {}
  local option_cycle_node = {}

  -- Build all the individual rows (and columns)
  local marker = 1 + rows * cols * (page - 1)
  for i = 1, rows do
    local col_nodes = {}
    local row_end = math.min(marker + cols - 1, #word_variable_list)
    for j = marker, row_end do
      local word_variable = word_variable_list[j]
      if not word_variable then break end
      -- Build the information for the node, as well as hover tooltip(s)
      local info = get_dictionary_entry(word_variable)
      local tooltip = {}
      tooltip[#tooltip+1] = { set = info.set, key = info.key }
      if info.extra_tooltips ~= nil then
        for _, additional_tooltips in ipairs(info.extra_tooltips) do
          tooltip[#tooltip+1] = additional_tooltips
        end
      end
      local button = {
        n = G.UIT.C,
        config = { align = "tm", padding = 0.1 },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = info.name,
              detailed_tooltip = tooltip,
              colour = G.C.WHITE,
              scale = 0.5,
              shadow = true,
              juice = true
            }
          },
        }
      }
      col_nodes[#col_nodes+1] = button
    end
    row_nodes[i] = {n=G.UIT.R, config={align="tm", minw = 3 * cols, minh = 0.7}, nodes=col_nodes}
    marker = marker + cols
  end

  -- Now we put the row nodes into an overall dictionary_rows


  local total_pages = math.ceil(#word_variable_list / (rows * cols))
  local cycle_options = {}
  for i = 1, total_pages do
    cycle_options[#cycle_options+1] = localize('k_page') .. " " .. i .. "/" .. total_pages
  end

  -- Holds the "[<] PAGE 1/X [>]" thing
  option_cycle_node[1] = {
    n = G.UIT.R,
    config = {
      align = "cm",
      padding = 0,
    },
    nodes = {
      create_option_cycle {
        options = cycle_options,
        w = 2.5,
        cycle_shoulders = true,
        opt_callback = 'dictionary_page',
        current_option = page,
        colour = G.C.RED,
        no_pips = true,
        focus_args = {snap_to = true, nav = 'wide'}
      }
    }
  }

  return {
    -- Root structure
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      padding = 0,
      colour = G.C.CLEAR
    },
    --nodes = row_nodes,
    -- The column containing dictionary box plus the option cycle
    nodes = {
      {
        n = G.UIT.C,
        config = {
          align = "cm",
          padding = 0
        },
        nodes = {
          -- contains dictionary box
          {
            n = G.UIT.R,
            config = {
              align = "cm",
              r = 0.1,
              padding = 0.1,
              minw = 8,
              colour = G.C.BLACK,
              emboss = 0.05
            },
            nodes = row_nodes
          },
          -- contains option cycle
          {
            n = G.UIT.R,
            config = {
              align = "cm",
              padding = 0,
            },
            nodes = option_cycle_node
          }
        }
      }
    }
  }
end



local dragqueen_dictionary_tab = function()
  return {
    label = localize("dragqueen_ui_dictionary"),
    tab_definition_function = function()
      return {
        n = G.UIT.ROOT,
        config = {
          align = "cm",
          padding = 0,
          r = 0.1,
          minw = 10,
          colour = G.C.CLEAR
        },
        -- "Dictionary" title
        nodes = {
          { n = G.UIT.R,
            config = {
              align = "tm",
              padding = 0.2,
              minh = 1.5
            },
            nodes = {
              { n = G.UIT.T,
                config = {
                  text = localize("dragqueen_ui_dictionary"),
                  colour = G.C.DRAGQUEEN_KEYWORD,
                  scale = 1,
                  shadow = true
                }
              }
            }
          },
          -- Display grid of dictionary entries
          {n = G.UIT.R,
            config = {
              align = "tm",
              padding = 0
            },
            nodes = {
              { n = G.UIT.O,
                config = {
                  id = "dragqueen_dictionary_grid_wrap",
                  object = UIBox {
                    definition = dictionary_tab_create_grid(),
                    config = { align = "cm" }
                  }
                }
              }
            }
          }
        }
      }
    end
  }
end



G.FUNCS.dragqueen_dictionary_page = function(e)
  if not e or not e.cycle_config then return end
  local page = e.cycle_config.current_option

  G.dictionary_grid_page = page

  if G.OVERLAY_MENU then
    ---@diagnostic disable-next-line: undefined-field
    local grid_wrap = G.OVERLAY_MENU:get_UIE_by_ID("dragqueen_dictionary_grid_wrap")

    grid_wrap.config.object:remove()
    grid_wrap.config.object = UIBox {
      definition = dictionary_tab_create_grid(),
      config = { parent = grid_wrap, type = "cm" }
    }

    grid_wrap.UIBox:recalculate()
  end
end



---@diagnostic disable-next-line: duplicate-set-field
SMODS.current_mod.extra_tabs = function()
  return {
    dragqueen_dictionary_tab()
  }
end



-- Create Credits tab in our mod UI

-- Create collection entries for Kisses if we have multiple types, or just stick them in stickers


------------------------------
-- Extending UI functionality
------------------------------



-- Alternative way to create a detailed tooltip from node from a function,
-- <br>as opposed to through info_tip_from_rows
--
---@see create_UIBox_detailed_tooltip
function DRAGQUEENMOD.create_UIBox_detailed_tooltip_from_function(_center)
end



------------------------------
-- Mod-specific tooltips
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



-- Dynamically create the "Accessorize" tooltip
---@param card table | Card -- Card to give tooltip to
---@return table -- Add to info_queue
function DRAGQUEENMOD.dragqueen_accessorize_tooltip(card)
  -- Assertions
  assert(type(card) == "table" or "Card", "object given to DRAGQUEENMOD.dragqueen_accessorize_tooltip() is not a card")
  assert(card.ability, "card given to DRAGQUEENMOD.dragqueen_accessorize_tooltip() does not have .ability")
  assert(card.ability.extra, "card.ability given to DRAGQUEENMOD.dragqueen_accessorize_tooltip() does not have .extra")
  assert(type(card.ability.extra.accessorize_suit) == "string", "suit given to DRAGQUEENMOD.dragqueen_accessorize_tooltip() is not a string")
  assert(type(card.ability.extra.accessorize_count) == "number", "count given to DRAGQUEENMOD.dragqueen_accessorize_tooltip() is not a number")

  local given_suit = card.ability.extra.accessorize_suit
  local suit_exists_check = false

  -- Checks if suit exists
  for suitcategory, suitsets in pairs(DRAGQUEENMOD.suit_groups) do
    for _, individual_suit in ipairs(suitsets) do
      if given_suit == individual_suit then
        suit_exists_check = true
      end
    end
  end
  assert(suit_exists_check == true, "DRAGQUEENMOD.dragqueen_accessorize_tooltip() could not find " .. given_suit)

  -- Find the associated suit-converting consumable card, make sure it exists
  local suit_consumable = DRAGQUEENMOD.suits_to_consumable[given_suit]
  assert(type(suit_consumable) == "string", "Could not find suit-converting consumable for suit " .. given_suit .. "for DRAGQUEENMOD.dragqueen_accessorize_tooltip()")

  -- Get the localized name for that consumable
  local suit_consumable_local_info = DRAGQUEENMOD.suits_to_consumable_local_description[given_suit].localization_entry
  local suit_consumable_local_name = DRAGQUEENMOD.easydescriptionlocalize(suit_consumable_local_info[1], suit_consumable_local_info[2]).name

  -- Build the tooltip
  local given_count = tostring(card.ability.extra.accessorize_count)
  local set = "Other"
  local key = "dragqueen_accessorize_tooltip"
  local text = {}
  local suit_color = DRAGQUEENMOD.suits_to_color[given_suit]
  if type(suit_color) ~= "string" then
    suit_color = "attention"
  end

  for index, string in ipairs(DRAGQUEENMOD.easydescriptionlocalize(set, key).text) do
    local subbed_string = ""
    subbed_string = string.gsub(string, "#1#", given_count)
    subbed_string = string.gsub(subbed_string, "#2#", suit_consumable_local_name)
    subbed_string = string.gsub(subbed_string, "#3#", suit_color)
    text[index] = subbed_string
  end

  -- We get the colors for "colours"
  local colours = {}
  colours[#colours+1] = G.C.SUITS[given_suit] or G.C.IMPORTANT
  colours[#colours+1] = G.C.FILTER
  colours[#colours+1] = loc_colour(DRAGQUEENMOD.suits_to_consumable_local_description[given_suit].consumable_color)
  colours[#colours+1] = G.C.UI.TEXT_INACTIVE

  -- We let Balatro's misc_functions.lua:loc_parse_string() handle the text
  local textparsed = {}
  for _, v in ipairs(text) do
    textparsed[#textparsed+1] = loc_parse_string(v)
  end

  -- For the grand finale we take our dynamically parsed text and give it back to localization
  G.localization.descriptions.Other[key .. "_dynamic"].text = text
  G.localization.descriptions.Other[key .. "_dynamic"].text_parsed = textparsed

  -- Now we return the table which can be handed to info_queue

  return {
    -- Balatro's functions/common_events.lua:function generate_card_ui() builds a full_UI_table.name
    -- which is parsed with Balatro's functions/misc_functions.lua:function localize(args, misc_cat)
    -- This return gets sent to localize() with type "Other", and using the suit and key the text table is given to loc_target

    -- "Colours" here comes from Balatro's own Canadian code
    set = "Other",
    key = key .. "_dynamic",
    vars = {
      colours = colours
    }
  }

end



-- Dynamically create a "suit to consumable" conversion table
-- <br>to be displayed in Dictionary for Accessorize
-- <br>Cannot be stored directly in localization as it'll be an organized table within a tooltip
---@param given_suits_to_consumable_entries table
---@param and_more? number
---@return table | nil
function DRAGQUEENMOD.suit_to_consumable_table_tooltip(given_suits_to_consumable_entries, and_more)
  local etc_amount = and_more or 0
  local suits_to_consumable_local_description = given_suits_to_consumable_entries
  if suits_to_consumable_local_description == nil then return end

  local suit_column = {}
  local consumable_column = {}
  local and_more_node = {}

  ------------------------------
  -- Spacers
  ------------------------------
  
  -- thin spacer between rows
  local horizontal_spacer_node = {
    n = G.UIT.R,
    config = {
      align = "cm",
      minh = 0.03
    }
  }

  -- thin spacer between columns
  local vertical_spacer_node = {
    n = G.UIT.C,
    config = {
      align = "cm",
      minw = 0.03
    }
  }
  ------------------------------
  -- Column titles, "and more" entry
  ------------------------------


  local suit_column_title = {
    n = G.UIT.R,
    config = {
      align = "tm",
      padding = 0
    },
    nodes = {
      { n = G.UIT.T,
        config = {
          align = "tm",
          text = DRAGQUEENMOD.easymisclocalize("dictionary", "dragqueen_ui_suit_to_consumable_table_suit"),
          scale = 0.36,
          colour = loc_colour("dragqueen_keyword")
        }
      }
    }
  }

  local consumable_column_title = {
    n = G.UIT.R,
    config = {
      align = "tm",
      padding = 0
    },
    nodes = {
      { n = G.UIT.T,
        config = {
          align = "tm",
          text = DRAGQUEENMOD.easymisclocalize("dictionary", "dragqueen_ui_suit_to_consumable_table_consumable"),
          scale = 0.36,
          colour = loc_colour("dragqueen_keyword")
        }
      }
    }
  }

  -- if there's more suits than we're willing to build, bottom of table will have "...And [number] more"
  if etc_amount > 0 then
    local and_more_localized_entry = DRAGQUEENMOD.easymisclocalize("dictionary", "dragqueen_ui_suit_to_consumable_table_and_more")
    local etc_count = string.gsub(tostring(and_more_localized_entry), "#1#", tostring(etc_amount))

    and_more_node = {
      n = G.UIT.R,
      config = {
        align = "cm"
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = "cm",
            padding = 0
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                text = etc_count,
                scale = 0.2,
                colour = G.C.UI.TEXT_INACTIVE
              }
            }
          }
        }
      }
    }
  end

  suit_column[#suit_column+1] = suit_column_title
  suit_column[#suit_column+1] = horizontal_spacer_node
  consumable_column[#consumable_column+1] = consumable_column_title
  consumable_column[#consumable_column+1] = horizontal_spacer_node

  ------------------------------
  -- Adding suit entries
  ------------------------------

  -- Now we put all the entries into the two columns
  for _, entry in pairs(suits_to_consumable_local_description) do
    ------------------------------
    -- Pulling data
    ------------------------------

    local suitname = DRAGQUEENMOD.easymisclocalize("suits_plural", entry.suit)
    local suitcolor = DRAGQUEENMOD.suits_to_color[entry.suit]
    local consumable = DRAGQUEENMOD.easydescriptionlocalize(entry.data.localization_entry[1], entry.data.localization_entry[2]).name
    local consumable_color = entry.data.consumable_color
    local consumable_category = nil

    ------------------------------
    -- Validating consumable categories
    ------------------------------

    if entry.data.consumable_category[1] == "misc" then
      consumable_category = DRAGQUEENMOD.easymisclocalize(entry.data.consumable_category[2], entry.data.consumable_category[3])
    elseif entry.data.consumable_category[1] == "descriptions" then
      consumable_category = DRAGQUEENMOD.easydescriptionlocalize(entry.data.consumable_category[2], entry.data.consumable_category[3])
    else
      error("suitdata.consumable_category[1] not \"misc\" or \"descriptions\"")
    end


    -- For the consumable description coloring to work, we build a dynamic (temporary) localization entry
    -- Kind of like `dragqueen_accessorize_tooltip_dynamic` for the accessory tooltip
    local dynamic_entry_text = { "{C:" .. consumable_color .. "}" .. consumable .."{}" .. " ({C:" .. consumable_color .. "}".. consumable_category .. "{})" }
    local dynamic_entry_text_parsed = {}
    for _, line in ipairs(dynamic_entry_text) do
      dynamic_entry_text_parsed[#dynamic_entry_text_parsed+1] = loc_parse_string(line)
    end

    ------------------------------
    -- Generating UI
    ------------------------------

    -- Pass the text and text_parsed to the dynamic localization entry
    if G.localization.descriptions.Other["dragqueen_suit_to_consumable_table_tooltip_dynamic"] == nil then
      G.localization.descriptions.Other["dragqueen_suit_to_consumable_table_tooltip_dynamic"] = { name = "Suit To Consumable Table", text = {} }
    end
    G.localization.descriptions.Other["dragqueen_suit_to_consumable_table_tooltip_dynamic"].text = dynamic_entry_text
    G.localization.descriptions.Other["dragqueen_suit_to_consumable_table_tooltip_dynamic"].text_parsed = dynamic_entry_text_parsed



    -- We now pull from the dynamic entry we build to pass to generate_card_ui
    local consumable_center = { set = "Other", key = "dragqueen_suit_to_consumable_table_tooltip_dynamic" }
    local full_UI_table = {
        main = {},
        info = {},
        type = {},
        name = 'done',
        badges = {}
    }

    -- We nab a card UI from generate_card_ui
    local consumable_card_ui = generate_card_ui(consumable_center, full_UI_table, nil, consumable_center.set, nil)

    -- This line is to clear some lines of text rendered on the screen after generate_card_ui is called, for some reason
    remove_all(G.STAGE_OBJECTS[G.STAGE])

    ------------------------------
    -- Building nodes
    ------------------------------

    -- We organize the information in the generated consumable_card_ui to be displayed
    -- This code is similar to Balatro's `info_tip_from_rows`
    ---@see info_tip_from_rows
    local consumable_info_as_nodes = {}
    for _, parts_of_text_as_nodes in ipairs(consumable_card_ui.info[1]) do
      -- We also need to manually set the scale for the pieces of text we're calling "parts_of_text_as_nodes"
      for _, part_of_text_as_a_node in ipairs(parts_of_text_as_nodes) do
        part_of_text_as_a_node.config.scale = 0.2
      end
      consumable_info_as_nodes[#consumable_info_as_nodes+1] = { n = G.UIT.R, config = { align = "cm" }, nodes = parts_of_text_as_nodes }
    end

    -- Now we take all the info we built and put it into a node on the left and right column
    local suit_column_instance = {
      n = G.UIT.R,
      config = {
        align = "cm",
        padding = 0
      },
      nodes = {
        { n = G.UIT.T,
          config = {
            align = "cm",
            text = suitname,
            scale = 0.2,
            colour = loc_colour(suitcolor)
          }
        }
      }
    }

    local consumable_column_instance = {
      n = G.UIT.R,
      config = {
        align = "cm",
        padding = 0
      },
      nodes = consumable_info_as_nodes
    }

    suit_column[#suit_column+1] = suit_column_instance
    consumable_column[#consumable_column+1] = consumable_column_instance
  end

  ------------------------------
  -- Building and sending remaining structure
  ------------------------------

  local titles_and_entries_node = {
    horizontal_spacer_node,
    horizontal_spacer_node,
    {
      n = G.UIT.R,
      config = {
        align = "cm"
      },
      nodes = {
        vertical_spacer_node,
        vertical_spacer_node,
        {
          n = G.UIT.C,
          config = {
            align = "cm",
            minw = 1
          },
          nodes = suit_column
        },
        vertical_spacer_node,
        {
          n = G.UIT.C,
          config = {
            align = "cm",
            minw = 2
          },
          nodes = consumable_column
        },
        vertical_spacer_node,
        vertical_spacer_node
      }
    }
  }

  table.insert(titles_and_entries_node, horizontal_spacer_node)


  if etc_amount > 0 then
    local structured_and_more_node = {
      n = G.UIT.R,
      config = {
        align = "cm"
      },
      nodes = {
        and_more_node
      }
    }

    table.insert(titles_and_entries_node, structured_and_more_node)
    table.insert(titles_and_entries_node, horizontal_spacer_node)
  end

  table.insert(titles_and_entries_node, horizontal_spacer_node)

  local suit_to_consumable_table_node = {
    n = G.UIT.C,
    config = {
      align = "cm"
    },
    -- Holds the table titles and entries
    nodes = titles_and_entries_node
  }

  ------------------------------
  -- Final node to return
  ------------------------------

  local tooltip_node = {
    n = G.UIT.ROOT,
    config = {
      align = "cm"
    },
    nodes = {
    { n = G.UIT.R,
      config = {
        align = "cm",
        colour = lighten(G.C.JOKER_GREY, 0.5),
        r = 0.1,
        padding = 0.05,
        emboss = 0.05
      },
        nodes = {
          -- Below looks similar to Balatro's info_tip_from_rows()
          {
            n = G.UIT.R,
            config = {
              align  = "cm",
              colour = lighten(G.C.GREY, 0.15),
              r = 0.1
            },
            nodes = {
              {
                -- "Suit to Consumable Table" Title
                n = G.UIT.R,
                config = {
                  align = "cm",
                  minh = 0.41,
                  padding = 0.06
                },
                nodes = {
                  {
                    n = G.UIT.T,
                    config = {
                      text = DRAGQUEENMOD.easymisclocalize("dictionary", "dragqueen_ui_suit_to_consumable_table"),
                      scale = 0.32,
                      colour = G.C.UI.TEXT_LIGHT
                    }
                  }
                },
              },
              -- suit_to_consumable tooltip
              {
                n = G.UIT.R,
                config = {
                  align = "cm",
                  minw = 1.5,
                  r = 0.1,
                  colour = G.C.WHITE
                },
                nodes = {
                  suit_to_consumable_table_node
                }
              }
            }
          }
        }
      }
    }
  }
  return tooltip_node
end



------------------------------
-- Badges
------------------------------



-- Puts a badge under a suited card indicating if it is a Light Suit, a Dark Suit, or both
function DRAGQUEENMOD.card_suit_badge(obj, badges)
  if obj then
    if obj.is_suit ~= nil and obj.key ~= nil and obj.base_card.config ~= nil then

      local dark_or_light_suittext, dark_or_light_badgecolor, dark_or_light_textcolor, neither_dark_nor_light = DRAGQUEENMOD.get_dark_or_light_suit_badge(obj)
      if (dark_or_light_suittext and dark_or_light_badgecolor and dark_or_light_textcolor) and neither_dark_nor_light == false then
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
  local is_dark = nil
  local is_light = nil
  local is_both_dark_and_light = nil
  local is_neither_dark_nor_light = nil


  for _, v in pairs(DRAGQUEENMOD.dark_suits) do
    if obj.key == v then
      is_dark = true
    end
  end
  for _, v in pairs(DRAGQUEENMOD.light_suits) do
    if obj.key == v then
      is_light = true
    end
  end

  -- Enhancements can override what the underlying card's suit is considered (ex. Stone Card, Wild Card)
  -- Enhancement is stored at obj.base_card.config.center.key as a string
  if SMODS.has_no_suit(obj.base_card) then
    is_dark = false
    is_light = false
  end

  if SMODS.has_any_suit(obj.base_card) then
    is_dark = true
    is_light = true
  end

  -- Patch target for DRAGQUEENMOD.get_dark_or_light_suit_badge if you want more conditions to be considered dark, light, or both

  if (is_dark == true and is_light == true) or is_both_dark_and_light == true then
    suitkey = "dragqueen_card_badge_dark_and_light_suit"
    badgecolor = G.C.DRAGQUEEN_DARK_AND_LIGHT_SUIT
    is_neither_dark_nor_light = false
  elseif is_dark == true then
    suitkey = "dragqueen_card_badge_dark_suit"
    badgecolor = G.C.DRAGQUEEN_DARK_SUIT
    is_neither_dark_nor_light = false
  elseif is_light == true then
    suitkey = "dragqueen_card_badge_light_suit"
    badgecolor = G.C.DRAGQUEEN_LIGHT_SUIT
    is_neither_dark_nor_light = false
  else
    is_neither_dark_nor_light = true
  end

  -- suitkey value check
  if (suitkey ~= nil) then
    if is_neither_dark_nor_light == false then
      suittext = DRAGQUEENMOD.easymisclocalize("dictionary", suitkey)
      assert(type(suittext) == "string", "issue pulling " .. suitkey .. " string in 'Jimbo in Drag' mod")
    elseif is_neither_dark_nor_light == true then
      -- Do nothing
    else
      print(suitkey)
      error("suitkey value in DRAGQUEENMOD.get_dark_or_light_suit_badge is nonsensical")
    end
  end

  return suittext, badgecolor, textcolor, is_neither_dark_nor_light
end



function DRAGQUEENMOD.get_suit_type_badge(obj, giventextcolor)
  local obj_suit_to_eval = obj.base_card.config.card.suit
  local obj_suit_category = nil
  local suittext = nil

  for suitcategory, suitsets in pairs(DRAGQUEENMOD.suit_groups) do
    for _, individual_suit in ipairs(suitsets) do
      if obj_suit_to_eval == individual_suit then
        obj_suit_category = suitcategory
      end
    end
  end

  -- Enhancements can override what the underlying card's suit is considered (ex. Stone Card, Wild Card)
  if SMODS.has_no_suit(obj.base_card) then
    obj_suit_category = nil
  end

  -- Patch target for DRAGQUEENMOD.get_suit_type_badge if you want say a particular enhancement to count as one of our suit categories

  if obj_suit_category ~= nil then
    local prefix = DRAGQUEENMOD.suit_types_to_mod_prefixes[obj_suit_category]
    local suitkey = "dragqueen_card_badge_" .. prefix .. obj_suit_category .. "_suit"
    local badgecolor = G.C["DRAGQUEEN_" .. string.upper(prefix) .. string.upper(obj_suit_category) .. "_SUIT"]
    local textcolor = giventextcolor or G.C.WHITE

    -- suitkey value check
    if suitkey ~= nil then
      suittext = DRAGQUEENMOD.easymisclocalize("dictionary", suitkey)
      assert(type(suittext) == "string", "issue pulling " .. suitkey .. " string in 'Jimbo in Drag' mod")
    end
    return suittext, badgecolor, textcolor
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
