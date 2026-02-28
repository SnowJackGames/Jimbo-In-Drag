local function dragqueen_dayjob_nightclub_sprite_change(card)
  local position = { x = 5, y = 0 }
  if card.ability then
    if card.ability.extra then
      if card.ability.extra.side then
        if card.ability.extra.side == "B" then
          position = { x = 6, y = 0 }
        end
      end
    end
  end
  return position
end

-- Borrows some structuring / code from Bunco's "Cassette"
SMODS.Joker {
  key = "dayjob_nightclub",
  config = {
    extra = {
      chips = 20,
      earn = 3,
      mult = 6,
      cost = 4,
      side = "A"
    }
  },
  rarity = 2,
  atlas = "Joker_Doodles",
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  dragqueen = {
    requires_jokers = true
  },


  loc_vars = function (self, info_queue, card)
    ------------------------------
    -- Getting info for display
    ------------------------------

    local vars = {
      card.ability.extra.chips,
      card.ability.extra.earn,
      card.ability.extra.mult,
      card.ability.extra.cost
    }

    local scale = 0.75

    -- Note about "On discard, flip this Joker"
    local flip_nodes = {}

    -- Builds into `flip_nodes`
    localize{
      type = "descriptions",
      set = "Joker",
      key = "j_dragqueen_dayjob_nightclub_extra",
      nodes = flip_nodes,
      vars = {},
      scale = scale
    }

    -- The other side's Joker text
    local other_side_nodes = {}

    -- Builds into `other_other_side_nodes
    localize{
      type = "descriptions",
      set = "Joker",
      key = "j_dragqueen_dayjob_nightclub_" .. (card.ability.extra.side == "A" and "b" or "a"),
      nodes = other_side_nodes,
      vars = vars,
      scale = scale
    }

    ------------------------------
    -- Structuring some info we need
    ------------------------------

    -- Structures flip_nodes to be injected as a set of nodes for display
    local structured_flip_nodes = {}

    for line = 1, #flip_nodes do
      local structured_node = {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = flip_nodes[line]
      }
      structured_flip_nodes[#structured_flip_nodes+1] = structured_node
    end

    -- Structures other_side_nodes to be injected as a set of nodes for display
    local structured_other_side_nodes = {}

    for line = 1, #other_side_nodes do
      local structured_node = {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = other_side_nodes[line]
      }
      structured_other_side_nodes[#structured_other_side_nodes+1] = structured_node
    end

    ---@diagnostic disable-next-line: undefined-field
    local descscale = G.LANG.font.DESCSCALE or 1

    ------------------------------
    -- Building main_end
    ------------------------------

    -- This portion is appended after the current side of the Joker's description tooltip, inside the white box
    local main_end = {
      { n = G.UIT.R,
        config = { align = "cm", padding = 0.08 },
        nodes = {
          -- Note about "On discard, flip this Joker"
          { n = G.UIT.R,
            config = { align = "cm" },
            nodes = structured_flip_nodes
          },

          -- UI box holding a mini version of the flipped side's UI
          { n = G.UIT.R,
            config = { align = "cm", padding = 0.08, colour = G.C.UI.BACKGROUND_DARK, r = 0.05 },
            nodes = {
              { n = G.UIT.R,
                config = {align = "cm"},
                nodes = {
                  -- Title being "Dayjob" or "Nightclub"
                  { n = G.UIT.O,
                    config = {
                      object = DynaText({
                        string = { G.localization.misc.dictionary["dragqueen_dayjob_nightclub_"..(card.ability.extra.side == "A" and "b" or "a")] },
                        colours = { G.C.WHITE },
                        scale = 0.32 * (scale) * descscale
                      })
                    }
                  }
                }
              },
              { n = G.UIT.R,
                config = {align = "cm", outline_colour = G.C.UI.BACKGROUND_WHITE, colour = G.C.UI.BACKGROUND_WHITE, outline = 1, r = 0.05, padding = 0.05},
                nodes = structured_other_side_nodes
              }
            }
          }
        }
      }
    }

    ------------------------------
    -- Dark / light suit tooltip
    ------------------------------


    -- Info tooltip for either dark or light suits 
    if card.ability.extra.side == "A" then
        info_queue[#info_queue + 1] = DRAGQUEENMOD.suit_tooltip("light")

        return {
          key = self.key .. "_a",
          main_end = main_end,
          vars = vars
        }
    else
        info_queue[#info_queue + 1] = DRAGQUEENMOD.suit_tooltip("dark")

        return {
          key = self.key .. "_b",
          main_end = main_end,
          vars = vars
        }
    end
  end,

  update = function (self, card)
    if card.VT.w <= 0 then
      local position = dragqueen_dayjob_nightclub_sprite_change(card)
      card.children.center:set_sprite_pos(position)
    end
  end,

  set_sprites = function (self, card, front)
    if self.discovered or card.bypass_discovery_center then
      local position = dragqueen_dayjob_nightclub_sprite_change(card)
      card.children.center:set_sprite_pos(position)
    end
  end,

  calculate = function (self, card, context)
    ------------------------------
    -- Flipping
    ------------------------------

    -- Whenever you discard, this card does the flip animation, ...
    if context.pre_discard and not context.blueprint then
      card:flip()
    end

    -- ... and then switches from Dayjob to Nightclub, or vice versa
    if context.flip and not context.blueprint and context.card_flipped == card then
      if card.ability.extra.side == "A" then
        card.ability.extra.side = "B"
      else
        card.ability.extra.side = "A"
      end
      return {
        message = G.localization.misc.dictionary["dragqueen_dayjob_nightclub_" .. (card.ability.extra.side == "B" and "b" or "a")],
        colour = G.C.RED
      }
    end

    ------------------------------
    -- Scoring dark or light suits
    ------------------------------

    if context.individual and context.cardarea == G.play then

      -- When scores, gives the Dayjob or Nightjob side benefit
      local other_card = context.other_card
      local side = card.ability.extra.side
      if other_card ~= nil then
        -- Dayjob side
        if side == "A" then
          if DRAGQUEENMOD.is_suit(other_card, "light") then
            ------------------------------
            -- Dayjob calculations
            ------------------------------

            -- Get number of unique light suits
            local unique_light_suits = DRAGQUEENMOD.get_unique_light_suits(context.scoring_hand)

            -- multiply by card.ability.extra.chips, and return that and money to earn
            local multiplied_chips = unique_light_suits * DRAGQUEENMOD.to_number(card.ability.extra.chips)

            return {
              chips = multiplied_chips,
              dollars = card.ability.extra.earn
            }
          end
        end

        -- Nightclub side
        if side == "B" then
          if DRAGQUEENMOD.is_suit(other_card, "dark") then
            ------------------------------
            -- Nightclub calculations
            ------------------------------

            -- get number of unique dark suits
            local unique_dark_suits = DRAGQUEENMOD.get_unique_dark_suits(context.scoring_hand)

            -- If total money < card.ability.extra.cost, don't do anything
            local existing_money = DRAGQUEENMOD.to_big(G.GAME.dollars) + (DRAGQUEENMOD.to_big(G.GAME.dollar_buffer or 0))

            if DRAGQUEENMOD.to_number(existing_money) > DRAGQUEENMOD.to_number(card.ability.extra.cost) then
              -- Otherwise, reduce total money by cost,
              ease_dollars(-card.ability.extra.cost, true)

              -- then multiply unique dark suits by card.ability.extra.mult, and return that
              local multiplied_mult = unique_dark_suits * DRAGQUEENMOD.to_number(card.ability.extra.chips)

              return {
                mult = multiplied_mult
              }
            end
          end
        end
      end
    end
  end
}