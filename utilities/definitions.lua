-- Load mod config
DRAGQUEENMOD.config = SMODS.current_mod.config

-- Enable optional features
SMODS.current_mod.optional_features = {
  retrigger_joker = true,
  post_trigger = true,
  quantum_enhancements = true,
}

-- Update values that get reset at the start of each round
---@diagnostic disable-next-line: duplicate-set-field
SMODS.current_mod.reset_game_globals = function (run_start)
    if run_start then
    end
end

DRAGQUEENMOD.credits = {
    artists = {
        color = G.C.MULT,
        entries = {
            "SnowJackGames",
            "lasagen"
        }
    },
    developers = {
        "KassLavender / polyphonetic"
    }
}


-- Define light and dark suits
DRAGQUEENMOD.dark_suits = {"Spades", "Clubs", "Purses"}
DRAGQUEENMOD.light_suits = {"Hearts", "Diamonds", "Pumps"}

-- Define modifiers
DRAGQUEENMOD.modifiers = {}




-- The user can disable specific Drag Queen Mod items by commenting them out if they hate it
-- But watch out!

DRAGQUEENMOD.BASE_POKER_HANDS = {

}

DRAGQUEENMOD.SUITS = {
    "Purses",
    "Pumps"
}

DRAGQUEENMOD.SUITS_CATEGORIES = {
    "Plain",
    "Accessory",
    "Light",
    "Dark"
}

DRAGQUEENMOD.BASE_RANKS = {
  "Ace",
  "King",
  "Queen",
  "Jack",
  "10",
  "9",
  "8",
  "7",
  "6",
  "5",
  "4",
  "3",
  "2"
}

DRAGQUEENMOD.RANKS = {
    "Mother",
}

DRAGQUEENMOD.BASE_POKER_HANDS = {
  "Straight Flush",
  "Four of a Kind",
  "Full House",
  "Flush",
  "Straight",
  "Three of a Kind",
  "Two Pair",
  "Pair",
  "High Card"
}

DRAGQUEENMOD.POKER_HANDS = {
  "Spectrum",
  "Straight_Spectrum",
  "Spectrum_House",
  "Spectrum_Five",
}


-- Modifiers
DRAGQUEENMOD.MODIFIERS = {
    ENHANCEMENTS = {
    },
    
    EDITIONS = {
    },

    STICKERS = {
    },

    KISSES = {
    },

    GEMSTONES = {
    }
}


-- Consumables
DRAGQUEENMOD.CONSUMABLES = {
    PLANETS = {
        "Quaor",
        "Haumea",
        "Sedna",
        "Makemake"
    },

    TAROT = {
    },

    SPECTRALS = {
        "Celebrity"
    },

    VOUCHERS = {
        "Serve"
    },

    PACKS = {
    },

    TAGS = {
    },

    FOURTYFIVEDEGREETAROT = {
    },

    COLORS = {
    }
}

-- Other Core Content
DRAGQUEENMOD.JOKERS = {
}

DRAGQUEENMOD.DECKS = {
}

DRAGQUEENMOD.BLINDS = {
    "Rent",
    "Gig"
}

DRAGQUEENMOD.SKINS = {
}

DRAGQUEENMOD.VANILLA_REWORKS = {

}


-- Cross-Mod Specific
DRAGQUEENMOD.SLEEVES = {
}

DRAGQUEENMOD.PARTNERS = {
}

DRAGQUEENMOD.CHARMS = {
}

-- Define kiss objects
DRAGQUEENMOD.kiss = SMODS.Sticker:extend{
    prefix_config = {key = true},
    should_apply = false,
    config = {},
    rate = 0,
    sets = {
        Default = true
    }

}

---@type SMODS.Consumable
DRAGQUEENMOD.Planet = SMODS.Consumable:extend{
    set = "Planet",
    is_dwarf = false,

    -- Descriptions of planets are all the same, so can just nab c_mercury
    process_loc_text = function(self)
      G.localization.descriptions[self.set][self.key] = {
        text = G.localization.descriptions[self.set].c_mercury.text
      }
    end,

    set_card_type_badge = function(self, card, badges)
      badges[#badges + 1] = create_badge(
        not self.is_dwarf and localize('k_planet_q') or localize('k_dwarf_planet'),
        get_type_colour(self, card),
        nil,
        1.2
      )
    end
    }