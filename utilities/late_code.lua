------------------------------
-- Late definitions
------------------------------
-- Code to be passed to `DRAGQUEENMOD.last_second_code()`, loaded last in `dragqueen.lua`


function DRAGQUEENMOD.build_custom_structure_dictionary_tooltips()
  for _, item in ipairs(DRAGQUEENMOD.dictionary) do
    if item.entry == "accessorize" then
      -- Make sure we're not duplicating this tooltip somehow
      local added_tooltip = false
      for _, tooltip in ipairs(item.extra_tooltips) do
        if tooltip.tooltip_from_function ~= nil then
          added_tooltip = true
        end
      end

      if added_tooltip == false then
        local special_tooltip = {tooltip_from_function = DRAGQUEENMOD.suit_to_consumable_table_tooltip()}
        table.insert(item.extra_tooltips, 2, special_tooltip)
      end
    end
  end
end



-- This builds a convenient table by which to parse every Balatro and modded localization entry,
-- <br><b>provided that</b> the entries are being stored in a localization file
-- <br><b>NOTE</b>: This cannot find entries that are stored in `loc_txt` entries for objects
-- 
-- <br> See the [SMODS Localization Page](https://github.com/Steamodded/smods/wiki/Localization) on their wiki
-- <br>If a localization entry sought from `DRAGQUEENMOD.easydescriptionlocalize` or `DRAGQUEENMOD.easymisclocalize`
-- <br>doesn't exist in the current language, it can try to find another entry in `DRAGQUEENMOD.backup_localization_entries`,
-- <br>which this function builds
--
function DRAGQUEENMOD.build_backup_localization()
  -- The below code is basically Balatro's `functions/misc-functions.lua:init_localization()` copy-pasted
  local function init_localization_instance(given_localization_instance)
    local localization_instance = given_localization_instance

    -- Make sure that if a particular variable being iterated over doesn't exist that we won't crash
    localization_instance.misc = localization_instance.misc or {}
    localization_instance.misc.v_dictionary = localization_instance.misc.v_dictionary or {}
    localization_instance.misc.v_text = localization_instance.misc.v_text or {}
    localization_instance.misc.tutorial = localization_instance.misc.tutorial or {}
    localization_instance.misc.quips = localization_instance.misc.quips or {}

    localization_instance.misc.v_dictionary_parsed = {}
    for k, v in pairs(localization_instance.misc.v_dictionary) do
      if type(v) == 'table' then
        localization_instance.misc.v_dictionary_parsed[k] = {multi_line = true}
        for kk, vv in ipairs(v) do
          localization_instance.misc.v_dictionary_parsed[k][kk] = loc_parse_string(vv)
        end
      else
        localization_instance.misc.v_dictionary_parsed[k] = loc_parse_string(v)
      end
    end
    localization_instance.misc.v_text_parsed = {}
    for k, v in pairs(localization_instance.misc.v_text) do
      localization_instance.misc.v_text_parsed[k] = {}
      for kk, vv in ipairs(v) do
        localization_instance.misc.v_text_parsed[k][kk] = loc_parse_string(vv)
      end
    end
    localization_instance.tutorial_parsed = {}
    for k, v in pairs(localization_instance.misc.tutorial) do
      localization_instance.tutorial_parsed[k] = {multi_line = true}
        for kk, vv in ipairs(v) do
          localization_instance.tutorial_parsed[k][kk] = loc_parse_string(vv)
        end
    end
    localization_instance.quips_parsed = {}
    for k, v in pairs(localization_instance.misc.quips or {}) do
      localization_instance.quips_parsed[k] = {multi_line = true}
        for kk, vv in ipairs(v) do
          localization_instance.quips_parsed[k][kk] = loc_parse_string(vv)
        end
    end
    for g_k, group in pairs(localization_instance) do
      if g_k == 'descriptions' then
        for _, set in pairs(group) do
          for _, center in pairs(set) do
            center.text_parsed = {}
            if not center.text then else
              for _, line in ipairs(center.text) do
                  if type(line) == 'table' then
                      center.text_parsed[#center.text_parsed+1] = {}
                      for _, new_line in ipairs(line) do
                          center.text_parsed[#center.text_parsed][#center.text_parsed[#center.text_parsed]+1] = loc_parse_string(new_line)
                      end
                  else
                      center.text_parsed[#center.text_parsed+1] = loc_parse_string(line)
                  end
              end
              center.name_parsed = {}
              for _, line in ipairs(type(center.name) == 'table' and center.name or {center.name}) do
                center.name_parsed[#center.name_parsed+1] = loc_parse_string(line)
              end
              if center.unlock then
                center.unlock_parsed = {}
                for _, line in ipairs(center.unlock) do
                  center.unlock_parsed[#center.unlock_parsed+1] = loc_parse_string(line)
                end
              end
            end
          end
        end
      end
    end

    return localization_instance
  end

  -- Let's make a copy of the recursive table
  local recurse = DRAGQUEENMOD.recursively_add_entries_from_one_table_into_another

  -- Each key is a language, each value is a localization instance
  -- <br>Ex. `{ en-us = {}, es-ES = {}, phyrexian = {} }` etc
  local contains_one_localization_set_per_language_found_in_mods = {}

  ------------------------------
  -- Grabbing Balatro localization entries
  ------------------------------


  for language, _ in pairs(G.LANGUAGES) do
    -- Let's make sure we add all the languages we know of to our table
    contains_one_localization_set_per_language_found_in_mods[language] = {}

    -- loc_table is the actual table with all the localization entries in it, kind of like `G.localization`
    ---@diagnostic disable-next-line: param-type-mismatch
    local loc_table = assert(loadstring(love.filesystem.read('localization/'..language..'.lua') or love.filesystem.read('localization/en-us.lua'), '=[localization "'..language..'.lua"]'))()
    local fully_parsed_loc_table = init_localization_instance(loc_table)

    -- We shove all the localization entries into the appropriate language
    contains_one_localization_set_per_language_found_in_mods[language] = recurse(fully_parsed_loc_table, contains_one_localization_set_per_language_found_in_mods[language])
  end


  ------------------------------
  -- Grabbing Modded localization entries
  ------------------------------


  -- Hold onto your butts. We're going to find every localization entry in every mod currently installed
  for _, mod_name in ipairs(NFS.getDirectoryItems(SMODS.MODS_DIR)) do
    local localization_file_path = SMODS.MODS_DIR.. "/" .. mod_name .. "/localization/"

    -- For every mod that has a localization directory, we go through their localization files (ex. en-us.lua)
    for _, mod_localization_file_name in ipairs(NFS.getDirectoryItems(localization_file_path)) do

      ------------------------------
      -- Seeing if this language already exists or not
      ------------------------------

      -- Strip the `.lua`
      local language_name_of_the_mod_localization_instance = string.gsub(mod_localization_file_name, ".lua", "")

      -- Let's determine if this language is already represented in `contains_one_localization_set_per_language_found_in_mods`
      local found_new_language = true
      
      for language, _ in pairs(contains_one_localization_set_per_language_found_in_mods) do

        if language == language_name_of_the_mod_localization_instance then
          found_new_language = false
        end
      end

      ------------------------------
      -- Putting the localization entries into our table
      ------------------------------
      
      -- Found a new language, so let's put it into our table
      if found_new_language == true then
        contains_one_localization_set_per_language_found_in_mods[language_name_of_the_mod_localization_instance] = {}
      end

      -- Absolute path for a mod's localization entry
      local mod_localization_file_path = localization_file_path .. mod_localization_file_name

      -- loc_table is the actual table with all the localization entries in it, kind of like `G.localization`
      ---@diagnostic disable-next-line: param-type-mismatch
      local loc_table = assert(loadstring(NFS.read(mod_localization_file_path), ('=[SMODS %s "%s"]'):format(mod_name, string.match(mod_localization_file_path, '[^/]+/[^/]+$'))))()

      -- We parse the loc_table, now the entries have like `text_parsed`, `name_parsed` etc values
      local fully_parsed_loc_table = init_localization_instance(loc_table)

      -- We shove all the localization entries into the appropriate language. Try saying the below a million times fast
      contains_one_localization_set_per_language_found_in_mods[language_name_of_the_mod_localization_instance] = recurse(fully_parsed_loc_table, contains_one_localization_set_per_language_found_in_mods[language_name_of_the_mod_localization_instance])
    end
  end

  -- Table of
  DRAGQUEENMOD.backup_localization_entries = contains_one_localization_set_per_language_found_in_mods
end
