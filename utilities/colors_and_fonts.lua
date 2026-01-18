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


-- Updates the current value of a "wavy color" (a color that shifts between two or more colors)
-- <br> Make sure code is efficient because it is called every tick;
-- i.e. reduce calls to global
-- <br> Colors are defined in DRAGQUEENMOD.sine_colors of the format
-- ```
-- DRAGQUEENMOD.sine_colors = {
--  first_wavy_color = {color1, color2, ...}
-- }
-- ```
-- where color1 etc maybe of the following formats:
-- ```
-- - HEX("FF00FF")                      -- Hex code
-- - G.C.RED                          -- color in G.C
-- - G.ARGS.LOC_COLOURS.dark_edition  -- color in G.ARGS.LOC_COLOURS
-- - {0, 0.5, 1, 1}                   -- table of r, g, b, a channels
-- ```
-- The format `loc_colour("mycolor")` is not recommended
-- as the function `loc_colour` may be updated by hooks at later points of runtime after
-- DRAGQUEENMOD.sine_colors is defined.
function DRAGQUEENMOD.wavy_color_updater(time)
  -- Please note how beautiful and smart I, Kassandra, am for figuring this all out
  local wavy_colors = {}
  local sosopaac = {}
  local sosopaac_index = 0
  local sine_colors = DRAGQUEENMOD.sine_colors
  local pi = math.pi
  local pairs = pairs
  local ipairs = ipairs

  -- Builds set_of_sets_of_points_along_a_circle for the first time
  if DRAGQUEENMOD.set_of_sets_of_points_along_a_circle == nil then
    if sine_colors ~= nil then
      for colorsetname, set_of_individual_colors in pairs(sine_colors) do
        if colorsetname ~= nil then
          -- Typechecking
          assert(type(colorsetname) == "string", "DRAGQUEENMOD.wavy_color_updater was sent colorsetname that is not a string")
          assert(type(set_of_individual_colors) == "table", "DRAGQUEENMOD.wavy_color_updater was sent a color " .. colorsetname.. " with 'set_of_individual_colors' that is not a table")

          local points = 0

          -- More typechecking and also determining the number of colors in the set
          for _, individual_color in ipairs(set_of_individual_colors) do
            local passed_individual_color = individual_color

            -- Could be a string to be passed to loc_colour, or a color table
            if type(passed_individual_color) == "string" then
              passed_individual_color = loc_colour(individual_color)
            end

            -- Make sure calculating 
            assert(type(passed_individual_color) == "table", "DRAGQUEENMOD.wavy_color_updater was sent a color of improper format in " .. colorsetname)
            for _, value in pairs(passed_individual_color) do
              assert(type(tonumber(value)) == "number", "DRAGQUEENMOD.wavy_color_updater was sent a color of improper format in " .. colorsetname)
            end
            points = points + 1
          end

          local set_of_points_along_a_circle = {}
          local pointdistance = 2 * pi
          local currentdistance = 0

          -- Divide the circle into the number of colors there are
          pointdistance = pointdistance / points

          for i = 1, points, 1 do
            set_of_points_along_a_circle[i] = currentdistance
            currentdistance = currentdistance + pointdistance
          end

          table.insert(sosopaac, set_of_points_along_a_circle)
        end
      end
    end

    -- Now set_of_sets_of_points_along_a_circle doesn't need to build again
    DRAGQUEENMOD.set_of_sets_of_points_along_a_circle = sosopaac
  else
    sosopaac = DRAGQUEENMOD.set_of_sets_of_points_along_a_circle
  end

  if sine_colors ~= nil then

    local unit_circle_position = 0
    local fmod = math.fmod
    local gammaToLinear = love.math.gammaToLinear
    local linearToGamma = love.math.linearToGamma
    local type = type
    local loc_colour = loc_colour

    for colorsetname, set_of_individual_colors in pairs(sine_colors) do
      if colorsetname ~= nil then
        sosopaac_index = sosopaac_index + 1
        local sosopaac_index_size = #sosopaac[sosopaac_index]
        
        -- If there's only one color there's no reason to mix it
        -- This is not intended usage of wavy_color_updater function however
        if sosopaac_index_size == 0 then    -- Skip
        elseif sosopaac_index_size == 1 then
          wavy_colors[colorsetname] = set_of_individual_colors[1]
        else
          -- Given unit_circle_position, find the two individual_colors that are closest
          -- Setting "before" to be the last color initially
          local point_before = sosopaac_index_size
          local point_after = 1

          -- We need slower speed if there's more colors
          local speed = 4 / (sosopaac_index_size)

          -- Find the unit_circle_position given time, in radians;
          -- value loops from 0 to 2pi
          unit_circle_position = fmod(time * speed, 2 * pi)

          -- Finds the latest color_point that unit_circle_position is at or after
          for color_point, point_radian in ipairs(sosopaac[sosopaac_index]) do
            if unit_circle_position == point_radian then
              point_before = color_point
              point_after = color_point
            elseif unit_circle_position > point_radian then
              point_before = color_point
              point_after = point_before + 1
            end
          end

          -- If point_after is beyond the number of points in the circle, it wraps to point 1
          if point_after > #sosopaac[sosopaac_index] then
            point_after = 1
          end

          local point_before_radians = sosopaac[sosopaac_index][point_before]
          local point_after_radians = sosopaac[sosopaac_index][point_after]

          if point_after_radians == 0 then
            point_after_radians = 2 * pi
          end
          
          local color_before = set_of_individual_colors[point_before]
          local color_after = set_of_individual_colors[point_after]
          local color_proportion = 0

          -- If colors are strings, then pull from loc_colour
          if type(color_before) == "string" then color_before = loc_colour(color_before) end
          if type(color_after) == "string" then color_after = loc_colour(color_after) end

          -- Don't divide by zero
          if (point_after_radians - point_before_radians) == 0 then
            color_proportion = 0
          else
            color_proportion = (unit_circle_position - point_before_radians) / (point_after_radians - point_before_radians)
          end

          -- "Degamma" (convert to linear sRGB) the colors before being mixed
          local degammaed_color_before = {0,0,1,1}
          local degammaed_color_after = {1,0,0,1}
          degammaed_color_before[1], degammaed_color_before[2], degammaed_color_before[3] = gammaToLinear(color_before[1], color_before[2], color_before[3])
          degammaed_color_after[1], degammaed_color_after[2], degammaed_color_after[3] = gammaToLinear(color_after[1], color_after[2], color_after[3])

          -- Alpha channel doesn't change when degammaed
          degammaed_color_before[4] = color_before[4]
          degammaed_color_after[4] = color_after[4]

          -- Note the order here when sent to mix_colours()
          local mixed_color = mix_colours(degammaed_color_after, degammaed_color_before, color_proportion)

          -- "Regamma" (convert to non-linear sRGB) the color after being mixed
          mixed_color[1], mixed_color[2], mixed_color[3] = linearToGamma(mixed_color[1], mixed_color[2], mixed_color[3])

          -- The degamma to regamma technique comes from https://archive.is/WfGUU
          -- If the two colors are red (FF0000) and green (00FF00), without converting from gamma to linear and back
          -- the midpoint is a murky brown
          -- With gamma awareness the midpoint is instead a yellowish color that preserves brightness

          wavy_colors[colorsetname] = mixed_color
        end
      end
    end
  end

  return wavy_colors
end


-- Lets Balatro load unusual Unicode characters for fun tooltip stuff
function DRAGQUEENMOD.font_symbols()
  -- "symbol-font.ttf" is a copy of the balatro m6x11plus.ttf font, with added characters from Bunco,
  -- and added characters created from SVG icons from BigBlueTermPlusNerdFont-Regular (see BigBlueTermPlusNerdFont-RegularSVG-assets-license.txt in /assets/fonts)
  -- used for suit symbols (see: /lovely/suitsymbols.toml)
  local font_location = DRAGQUEENMOD.dragqueen_path_from_save_folder .. "assets/fonts/"
  local symbol_font = love.graphics.newFont(font_location .. "symbol-font.ttf", G.TILESIZE * 10)
  local nerd_font = love.graphics.newFont(font_location .. "BigBlueTermPlusNerdFontPropo-Regular.ttf", G.TILESIZE * 8)
  for i, v in ipairs(G.FONTS) do
    G.FONTS[i].FONT:setFallbacks(symbol_font, nerd_font)
  end
end