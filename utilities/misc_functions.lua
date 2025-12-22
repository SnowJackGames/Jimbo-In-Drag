---Registers a list of items in a custom order
---@param items table
---@param path string
function DRAGQUEENMOD.register_items(items, path)
  for i = 1, #items do
    SMODS.load_file(path .. "/" .. items[i] .. ".lua")()
  end
end