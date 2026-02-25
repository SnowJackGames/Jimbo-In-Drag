SMODS.Consumable{
  set = "Tarot",
  key = "the_empress_reversed",
  name = "The Empress Reversed",
  atlas = "Tarot",
  pos = { x = 2, y = 0 },
  cost = 5,
  discovered = true,

  config = { max_highlighted = 1, rank_conv = "dragqueen_Mother" },

  loc_vars = function(self, info_queue, card)
    local key = self.key
    if card.ability.consumeable.max_highlighted == 1 then
      key = key .. "_singular"
    else
      key = key .. "_plural"
    end

    return {
      vars = {
        card.ability.consumeable.max_highlighted
      }
    }
  end,

  use = function(self, card, area, copier)
    if G.hand.highlighted and #G.hand.highlighted == card.ability.consumeable.max_highlighted then
      for _, selected_card in pairs(G.hand.highlighted) do
        DRAGQUEENMOD.convert_cards_to(selected_card, {rank_conv = "dragqueen_Mother"}, true)
      end
    end
  end,

  in_pool = function()
    return true
  end
}