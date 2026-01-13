SMODS.Suit{
    key = "Pumps",
    card_key = "PUMPS",

    lc_atlas = "lc_cards",
    hc_atlas = "hc_cards",

    lc_ui_atlas = "lc_ui",
    hc_ui_atlas = "hc_ui",

    lc_color = G.C.DRAGQUEEN_PUMPS_LC,
    hc_colour = G.C.DRAGQUEEN_PUMPS_HC,

    pos = {y = 0},
    ui_pos = {x = 0, y = 0},

    in_pool = function(self, args)
        -- Allows forcing this suit to be included
        if args and args.dragqueen and args.dragqueen.include_pumps then
            return true
        end

    if args and args.initial_deck then
      -- When creating a deck
      local back = G.GAME.selected_back
      local back_config = back and back.effect.center.dragqueen

      local sleeve = G.GAME.selected_sleeve
      local sleeve_config = (G.P_CENTERS[sleeve] or {}).dragqueen

      return (back_config and back_config.create_pumps)
          or (sleeve_config and sleeve_config.create_pumps)
    else
      -- If not creating a deck
      return DRAGQUEENMOD.has_suit_in_deck('dragqueen_Pumps', true) or DRAGQUEENMOD.non_plain_in_pool()
    end
  end
}