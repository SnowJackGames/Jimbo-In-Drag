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