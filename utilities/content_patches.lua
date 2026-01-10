---@diagnostic disable: undefined-field
function DRAGQUEENMOD.SpectrumFramework_spectrum_played_hook()
  local drag_queen_hook_spectrum_played = SPECF.spectrum_played
  function SPECF.spectrum_played()
    if DRAGQUEENMOD.non_plain_in_pool() then
      return true
    end
  end
  drag_queen_hook_spectrum_played()
end


function DRAGQUEENMOD.Bunco_joker_patch()
  local cassette = {
    discovered = true,
    custom_vars = function(self, info_queue, card)
        local vars = {card.ability.extra.chips, card.ability.extra.mult}

        local scale = 0.75

        local flip_nodes = {}
        localize{type = 'descriptions', set = 'Joker', key = 'j_bunc_cassette_extra', nodes = flip_nodes, vars = {}, scale = scale}

        local side_nodes = {}
        localize{type = 'descriptions', set = 'Joker', key = 'j_bunc_cassette_'..(card.ability.extra.side == 'A' and 'b' or 'a'), nodes = side_nodes, vars = vars, scale = scale}

        local main_end = {
            {n = G.UIT.R, config = {align = "cm", padding = 0.08}, nodes = {
                {n = G.UIT.R, config = {align = "cm"}, nodes =
                    flip_nodes[1]
                },
                {n = G.UIT.R, config = {align = "cm", padding = 0.08, colour = G.C.UI.BACKGROUND_DARK, r = 0.05}, nodes = {
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.O, config = {
                            object = DynaText({string = {G.localization.misc.dictionary['bunc_'..(card.ability.extra.side == 'A' and 'b' or 'a')..'_side']}, colours = {G.C.WHITE},
                            scale = 0.32 * (scale) * G.LANG.font.DESCSCALE})
                        }},
                    }},
                    {n = G.UIT.R, config = {align = "cm", outline_colour = G.C.UI.BACKGROUND_WHITE, colour = G.C.UI.BACKGROUND_WHITE, outline = 1, r = 0.05, padding = 0.05}, nodes = {
                        {n = G.UIT.R, config = {align = "cm"}, nodes =
                            side_nodes[1]
                        },
                        {n = G.UIT.R, config = {align = "cm"}, nodes =
                            side_nodes[2]
                        }
                    }}
                }},
            }}
        }

        if card.ability.extra.side == 'A' then
            info_queue[#info_queue + 1] = DRAGQUEENMOD.suit_tooltip('light')

            return {key = self.key..'_a',
            main_end = main_end,
            vars = vars}
        else
            info_queue[#info_queue + 1] = DRAGQUEENMOD.suit_tooltip('dark')

            return {key = self.key..'_b',
            main_end = main_end,
            vars = vars}
        end
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card:flip()
        end

        if context.flip and not context.blueprint and context.card_flipped == card then
            if card.ability.extra.side == 'A' then
                card.ability.extra.side = 'B'
            else
                card.ability.extra.side = 'A'
            end
            return {
                message = G.localization.misc.dictionary['bunc_'..(card.ability.extra.side == 'A' and 'a' or 'b')..'_side'],
                colour = G.C.RED
            }
        end

        if context.individual and context.cardarea == G.play then

            local other_card = context.other_card
            local side = card.ability.extra.side


            if DRAGQUEENMOD.is_suit(other_card, "light") then
                if side == 'A' then
                    return {
                        chips = card.ability.extra.chips
                    }
                end
            end

            if DRAGQUEENMOD.is_suit(other_card, "dark") then
                if side == 'B' then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    end,
  }

  SMODS.Joker:take_ownership("bunc_cassette", cassette, true)
end