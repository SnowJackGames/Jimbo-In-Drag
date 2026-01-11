-- Load mod config
DRAGQUEENMOD.config = SMODS.current_mod.config

-- Get this mod's path
DRAGQUEENMOD.dragqueen_path = string.gsub(tostring(SMODS.Mods["dragqueen"].path), "\\", "/")
DRAGQUEENMOD.dragqueen_path_from_save_folder = string.gsub(DRAGQUEENMOD.dragqueen_path,
  love.filesystem.getSaveDirectory(), "")

-- Enable optional features
SMODS.current_mod.optional_features = {
  retrigger_joker = false,
  post_trigger = false,
  quantum_enhancements = false,
  cardareas = { deck = false, discard = false }
}

-- Update values that get reset at the start of each round
---@diagnostic disable-next-line: duplicate-set-field
SMODS.current_mod.reset_game_globals = function(run_start)
  if run_start then
  end
end

DRAGQUEENMOD.credits = {
  artists = {
    color = G.C.MULT,
    entries = {
      "birdofalltrades",
      "lasagen"
    }
  },
  developers = {
    "KassLavender aka polyphonetic"
  }
}


-- Define some suit categories
DRAGQUEENMOD.dark_suits = { "Spades", "Clubs", "Purses" }
DRAGQUEENMOD.light_suits = { "Hearts", "Diamonds", "Pumps" }
DRAGQUEENMOD.base_suits = { "Spades", "Hearts", "Clubs", "Diamonds" }
DRAGQUEENMOD.modded_suits = { "dragqueen_Purses", "dragqueen_Pumps" }

-- Red, Green, Blue, Alpha; called by DRAGQUEENMOD.wavy_color_updater()
DRAGQUEENMOD.sine_colors = {
  DRAGQUEEN_KEYWORD = {
    { 0.9254901960784314, 0.7137254901960784, 0.8588235294117647, 1 },
    { 0.9333333333333333, 0.7647058823529411, 0.6039215686274509, 1 }
  }
}

-- every type but light and dark has a clear-cut answer
-- "plain" and "accessory" don't have a mod prefix bc they're only referenced in our mod
DRAGQUEENMOD.suit_types_to_mod_prefixes = {
  ["plain"] = "",
  ["accessory"] = "",
  ["exotic"] = "bunc_",
  ["proud"] = "paperback_",
  ["night"] = "six_",
  ["treat"] = "minty_",
  ["magic"] = "mtg_",
  ["stained"] = "ink_",
  ["parallel"] = "rgmc_",
  ["chaotic"] = "rgmc_",
  ["tictactoe"] = "unik_",
}

DRAGQUEENMOD.suits_to_tarot = {
  ["Spades"] = "c_world",
  ["Hearts"] = "c_sun",
  ["Clubs"] = "c_moon",
  ["Diamonds"] = "c_star"
  --["dragqueen_purses"] =
  --["dragqueen_pumps"] =
}

DRAGQUEENMOD.valid_playing_card_set_categories = {"Playing Card", "Base", "Enhanced"}

-- Define modifiers
DRAGQUEENMOD.modifiers = {}




-- The user can disable specific Drag Queen Mod items by commenting them out if they hate it
-- But watch out!


DRAGQUEENMOD.SUITS = {
  "Purses",
  "Pumps"
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

DRAGQUEENMOD.SPECTRUM_POKER_HANDS = {
  "Spectrum",
  "Straight Spectrum",
  "Spectrum House",
  "Spectrum Five",
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
  "broke_joker",
  "vain_joker",
  "lipstick",
  "tights"
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

DRAGQUEENMOD.requirement_map = {
  requires_jokers = {
    setting = "jokers_enabled",
    tooltip = "dragqueen_requires_jokers"
  },
  requires_decks = {
    setting = "decks_enabled",
    tooltip = "dragqueen_requires_decks"
  },
  requires_blinds = {
    setting = "blinds_enabled",
    tooltip = "dragqueen_requires_blinds"
  },
  requires_skins = {
    setting = "skins_enabled",
    tooltip = "dragqueen_requires_skins"
  },
  requires_cross_mods = {
    setting = "cross_mod_enabled",
    tooltip = "dragqueen_requires_cross_mods"
  }
}

-- Define kiss objects
DRAGQUEENMOD.kiss = SMODS.Sticker:extend {
  prefix_config = { key = true },
  should_apply = false,
  config = {},
  rate = 0,
  sets = {
    Default = true
  }

}
