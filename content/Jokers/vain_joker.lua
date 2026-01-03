SMODS.Joker {
    key = "vain_joker",
    effect = "Suit Mult",
    config = {
        extra = {
            s_mult = 5,
            suit = "dragqueen_pumps"
        }
    },
    rarity = 1,
    pos = {x = 0, y = 0},
    atlas = "placeholder",
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    dragqueen = {
        requires_pumps = true
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.s_mult
            }
        }
    end
}