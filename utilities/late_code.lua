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



-- If a localization entry sought from `DRAGQUEENMOD.easydescriptionlocalize` or `DRAGQUEENMOD.easymisclocalize`
-- <br>doesn't exist in the current language, we try to find the entry in en-us as a backup.
function DRAGQUEENMOD.build_backup_en_us_localization()
  local backup_en_us_localization = assert(loadstring(love.filesystem.read("localization/en-us.lua")))()

  -- The below code is basically Balatro's `functions/misc-functions.lua:init_localization()` copy-pasted
  backup_en_us_localization.misc.v_dictionary_parsed = {}
  for k, v in pairs(backup_en_us_localization.misc.v_dictionary) do
    if type(v) == 'table' then
      backup_en_us_localization.misc.v_dictionary_parsed[k] = {multi_line = true}
      for kk, vv in ipairs(v) do
        backup_en_us_localization.misc.v_dictionary_parsed[k][kk] = loc_parse_string(vv)
      end
    else
      backup_en_us_localization.misc.v_dictionary_parsed[k] = loc_parse_string(v)
    end
  end
  backup_en_us_localization.misc.v_text_parsed = {}
  for k, v in pairs(backup_en_us_localization.misc.v_text) do
    backup_en_us_localization.misc.v_text_parsed[k] = {}
    for kk, vv in ipairs(v) do
      backup_en_us_localization.misc.v_text_parsed[k][kk] = loc_parse_string(vv)
    end
  end
  backup_en_us_localization.tutorial_parsed = {}
  for k, v in pairs(backup_en_us_localization.misc.tutorial) do
    backup_en_us_localization.tutorial_parsed[k] = {multi_line = true}
      for kk, vv in ipairs(v) do
        backup_en_us_localization.tutorial_parsed[k][kk] = loc_parse_string(vv)
      end
  end
  backup_en_us_localization.quips_parsed = {}
  for k, v in pairs(backup_en_us_localization.misc.quips or {}) do
    backup_en_us_localization.quips_parsed[k] = {multi_line = true}
      for kk, vv in ipairs(v) do
        backup_en_us_localization.quips_parsed[k][kk] = loc_parse_string(vv)
      end
  end
  for g_k, group in pairs(backup_en_us_localization) do
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

  DRAGQUEENMOD.backup_en_us_localization = backup_en_us_localization

  print(backup_en_us_localization)
end