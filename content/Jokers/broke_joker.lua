SMODS.Joker {
    key = "broke_joker",
    effect = "Suit Mult",
    config = {
        extra = {
            s_mult = 5,
            suit = "dragqueen_purses"
        }
    },
    rarity = 1,
    pos = {},
    atlas = "jokers_atlas",
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    dragqueen = {
        requires_purses = true
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.s_mult
            }
        }
    end
}