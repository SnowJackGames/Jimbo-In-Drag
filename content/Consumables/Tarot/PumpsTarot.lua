SMODS.Consumable{
  set = "Tarot",
  key = "pumps_placeholder",
  name = "The Pumps Placeholder",
  atlas = "Tarot",
  pos = { x = 0, y = 0 },
  unlocked = true,

  config = {max_highlighted = 3, suit_conv = 'dragqueen_Pumps'},

  loc_vars = function(self, info_queue, card)
    local key = self.key
    if card.ability.Consumable.max_highlighted ~= 1 then
      G.localization.descriptions.tarot.c_dragqueen_pumps_tarot.text = G.localization.descriptions.tarot.c_dragqueen_pumps_tarot.textplural
    else
      G.localization.descriptions.tarot.c_dragqueen_pumps_tarot.text = G.localization.descriptions.tarot.c_dragqueen_pumps_tarot.textsingular
    end
    return {
      key = key,
      vars = {
        card.ability.Consumable.max_highlighted
      }
    }
  end,

  dragqueen = {
    requires_custom_suits = true
  }
}