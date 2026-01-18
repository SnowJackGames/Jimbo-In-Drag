function DRAGQUEENMOD.color_register()
  for color, value in pairs(DRAGQUEENMOD.global_colors) do
    G.C[color] = value
  end
end



function DRAGQUEENMOD.color_register_into_LOC_COLOURS()
  for color, value in pairs(DRAGQUEENMOD.inject_into_loc_colours) do
    G.ARGS.LOC_COLOURS[color] = value
  end
end