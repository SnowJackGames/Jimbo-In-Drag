SMODS.Consumable{
  set = "Tarot",
  key = "purses_placeholder",
  name = "The Purses Placeholder",
  atlas = "Tarot",
  pos = { x = 0, y = 0 },
  discovered = true,

  config = { max_highlighted = 3, suit_conv = "dragqueen_Pumps" },

  loc_vars = function(self, info_queue, card)
    local key = self.key
    if card.ability.consumeable.max_highlighted == 1 then
      key = key .. "_singular"
    else
      key = key .. "_plural"
    end

    return {
      key = key,
      vars = {
        card.ability.consumeable.max_highlighted
      }
    }
  end,

  dragqueen = {
    requires_custom_suits = true
  }
}