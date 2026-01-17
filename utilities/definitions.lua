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
DRAGQUEENMOD.dark_suits = { "Spades", "Clubs", "dragqueen_Purses" }
DRAGQUEENMOD.light_suits = { "Hearts", "Diamonds", "dragqueen_Pumps" }
DRAGQUEENMOD.base_suits = { "Spades", "Hearts", "Clubs", "Diamonds" }
DRAGQUEENMOD.modded_suits = { "dragqueen_Purses", "dragqueen_Pumps" }

-- Called by DRAGQUEENMOD.wavy_color_updater()
DRAGQUEENMOD.sine_colors = {
  DRAGQUEEN_KEYWORD = {
    G.ARGS.LOC_COLOURS["dragqueen_pumps"],
    G.ARGS.LOC_COLOURS["dragqueen_purses"]
  },
  DRAGQUEEN_RAINBOW = {
    HEX("FF0000"),  -- Red
    HEX("FFFF00"),  -- Yellow
    HEX("00FF00"),  -- Green
    HEX("00FFFF"),  -- Cyan
    HEX("0000FF"),  -- Blue
    HEX("FF00FF"),  -- Magenta
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


DRAGQUEENMOD.base_poker_hands = {
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

DRAGQUEENMOD.spectrum_poker_hands = {
  "Spectrum",
  "Straight Spectrum",
  "Spectrum House",
  "Spectrum Five",
}

DRAGQUEENMOD.base_ranks = {
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

-- The user can disable specific Drag Queen Mod items in the "enabled" tables
-- by commenting them out if they hate it
-- But watch out!


DRAGQUEENMOD.ENABLEDSUITS = {
  "purses",
  "pumps"
}

DRAGQUEENMOD.ENABLEDRANKS = {
  "Mother",
}

-- Modifiers
DRAGQUEENMOD.MODIFIERS = {
  ENABLEDENHANCEMENTS = {
  },

  ENABLEDEDITIONS = {
  },

  ENABLEDSTICKERS = {
  },

  ENABLEDKISSES = {
  },

  ENABLEDGEMSTONES = {
  }
}

-- Consumables
DRAGQUEENMOD.CONSUMABLES = {

  ENABLEDTAROT = {
  },

  ENABLEDSPECTRALS = {
    "Celebrity"
  },

  ENABLEDVOUCHERS = {
    "Serve"
  },

  ENABLEDPACKS = {
  },

  ENABLEDTAGS = {
  },

  ENABLEDFOURTYFIVEDEGREETAROT = {
  },

  ENABLEDCOLORS = {
  }
}

-- Other Core Content
DRAGQUEENMOD.ENABLEDJOKERS = {
  "broke_joker",
  "vain_joker",
  "lipstick",
  "tights"
}

DRAGQUEENMOD.ENABLEDDECKS = {
  "accessory"
}

DRAGQUEENMOD.ENABLEDBLINDS = {
  "Rent",
  "Gig"
}

DRAGQUEENMOD.ENABLEDSKINS = {
}

DRAGQUEENMOD.ENABLEDVANILLA_REWORKS = {

}

-- Cross-Mod Specific
DRAGQUEENMOD.ENABLEDSLEEVES = {
}

DRAGQUEENMOD.ENABLEDPARTNERS = {
}

DRAGQUEENMOD.ENABLEDCHARMS = {
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
