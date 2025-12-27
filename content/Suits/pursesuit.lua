SMODS.suit{
    key = "Purses",
    card_key = "PURSES",

    lc_atlas = "purseslc",
    hc_atlas = "purseshc",

    lc_ui_atlas = "pursesuiticonlc",
    hc_ui_atlas = "pursesuiticonhc",

    lc_color = G.C.DRAGQUEEN_PURSES_LC,
    hc_colour = G.C.DRAGQUEEN_PURSES_HC,

    pos = {y = 0},
    ui_pos = {x = 0, y = 0},

    in_pool = function(self, args)
        -- Allows forcing this suit to be included
        if args and args.dragqueen then
            return true
        end

    if args and args.initial_deck then
      -- When creating a deck
      local back = G.GAME.selected_back
      local back_config = back and back.effect.center.dragqueen

      local sleeve = G.GAME.selected_sleeve
      local sleeve_config = (G.DQ_CENTERS[sleeve] or {}).dragqueen

      return (back_config and back_config.create_purses)
          or (sleeve_config and sleeve_config.create_pumps)
    else
      -- If not creating a deck
      return DRAGQUEENMOD.has_suit_in_deck('dragqueen_Purses', true) or DRAGQUEENMOD.non_plain_in_pool()
    end
  end
}