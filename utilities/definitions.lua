------------------------------
-- SMODS stuff, mod path stuff
------------------------------



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



------------------------------
-- Mod info tabs, collection
------------------------------



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



-- Referenced by the Dictionary tab in the mod's entry
-- <br>Can optionally define additional tooltips
-- Entries automatically sorted by localized alphabet
DRAGQUEENMOD.dictionary = {
  {
    entry = "accessorize",
    extra_tooltips = {
      {
        category = "descriptions",
        set = "Tarot",
        key = "c_sun"
      }
    }
  },
  {
    entry = "slay"
  }
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



------------------------------
-- Colors
------------------------------
-- Can be built into via cross-mod.lua



DRAGQUEENMOD.inject_into_loc_colours = {
  dragqueen_light_suit = G.C.DRAGQUEEN_LIGHT_SUIT,
  dragqueen_dark_suit = G.C.DRAGQUEEN_DARK_SUIT,
  dragqueen_dark_and_light_suit = G.C.DRAGQUEEN_DARK_AND_LIGHT_SUIT,
  dragqueen_pumps = G.C.SUITS.dragqueen_Pumps or G.C.DRAGQUEEN_PUMPS_LC,
  dragqueen_purses = G.C.SUITS.dragqueen_Purses or G.C.DRAGQUEEN_PURSES_LC,
  dragqueen_keyword = G.C.DRAGQUEEN_KEYWORD,
  dragqueen_rainbow = G.C.DRAGQUEEN_RAINBOW,
  rgmc_blooms = G.C.SUITS.rgmc_blooms or G.C.RGMC_BLOOMS or HEX('A7EE5F'),
  rgmc_daggers = G.C.SUITS.rgmc_daggers or G.C.RGMC_DAGGERS or HEX('591235'),
  rgmc_lanterns = G.C.SUITS.rgmc_lanterns or G.C.RGMC_LANTERNS or HEX('F09B4A'),
  rgmc_voids = G.C.SUITS.rgmc_voids or G.C.RGMC_VOIDS or HEX('564C53'),
  ink_inks = G.C.SUITS.ink_Inks or G.C.INK_INKS or HEX('374649'),
  ink_colors = G.C.SUITS.ink_Colors or G.C.INK_COLORS or HEX('eb8920'),
}



-- Called by `DRAGQUEENMOD.wavy_color_updater()`
---@see DRAGQUEENMOD.wavy_color_updater
DRAGQUEENMOD.sine_colors = {
  DRAGQUEEN_KEYWORD = {
    "dragqueen_pumps",
    "dragqueen_purses"
  },
  DRAGQUEEN_RAINBOW = {
    HEX("FF0000"),  -- Red
    HEX("FFFF00"),  -- Yellow
    HEX("00FF00"),  -- Green
    HEX("00FFFF"),  -- Cyan
    HEX("0000FF"),  -- Blue
    HEX("FF00FF"),  -- Magenta
  },
  DRAGQUEEN_DARK_AND_LIGHT_SUIT = {
    "dragqueen_light_suit",
    "dragqueen_light_suit",
    "dragqueen_dark_suit",
    "dragqueen_dark_suit",
  },
  DRAGQUEEN_PLAIN_SUIT = {
    "spades", "spades",
    "hearts", "hearts",
    "clubs", "clubs",
    "diamonds", "diamonds",
  },
  DRAGQUEEN_ACCESSORY_SUIT = {
    "dragqueen_pumps", "dragqueen_pumps",
    "dragqueen_purses", "dragqueen_purses",
  }
}



------------------------------
-- Dynamic references
------------------------------
-- Can be built into via cross-mod.lua



DRAGQUEENMOD.valid_playing_card_set_categories = {"Playing Card", "Base", "Enhanced"}



-- Define modifiers
DRAGQUEENMOD.modifiers = {}



-- Define some suit categories
DRAGQUEENMOD.dark_suits = { "Spades", "Clubs", "dragqueen_Purses" }
DRAGQUEENMOD.light_suits = { "Hearts", "Diamonds", "dragqueen_Pumps" }
DRAGQUEENMOD.modded_suits = { "dragqueen_Purses", "dragqueen_Pumps" }
DRAGQUEENMOD.suit_groups = {
  ["plain"] = { "Spades", "Hearts", "Clubs", "Diamonds"},
  ["accessory"] = { "dragqueen_Purses", "dragqueen_Pumps" }
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
  ["Diamonds"] = "c_star",
  ["dragqueen_Purses"] = "c_dragqueen_purses_placeholder",
  ["dragqueen_Pumps"] = "c_dragqueen_pumps_placeholder"
}


DRAGQUEENMOD.suits_to_tarot_local_description = {
  ["Spades"] = { { "Tarot", "c_world"} },
  ["Hearts"] = { { "Tarot", "c_sun" } },
  ["Clubs"] = { { "Tarot", "c_moon" } },
  ["Diamonds"] = { { "Tarot", "c_star" } },
  ["dragqueen_Purses"] = {
    { "Tarot", "c_dragqueen_purses_placeholder_plural" },
    { "Tarot", "c_dragqueen_purses_placeholder_singular" }
  },
  ["dragqueen_Pumps"] = {
    { "Tarot", "c_dragqueen_pumps_placeholder_plural" },
    { "Tarot", "c_dragqueen_pumps_placeholder_singular" }
  }
}



DRAGQUEENMOD.suits_to_color = {
  ["Spades"] = "spades",
  ["Hearts"] = "hearts",
  ["Clubs"] = "clubs",
  ["Diamonds"] = "diamonds",
  ["dragqueen_Purses"] = "dragqueen_purses",
  ["dragqueen_Pumps"] = "dragqueen_pumps"
}



------------------------------
-- Base / dependancy reference
------------------------------



DRAGQUEENMOD.base_suits = { "Spades", "Hearts", "Clubs", "Diamonds" }



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



------------------------------
-- Core content 
------------------------------
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



DRAGQUEENMOD.ENABLEDJOKERS = {
  "broke_joker",
  "vain_joker",
  "lipstick",
  "tights",
  "shoes"
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
    "PursesTarot",
    "PumpsTarot"
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



------------------------------
-- Cross-mod specific stuff
------------------------------



DRAGQUEENMOD.ENABLEDSLEEVES = {
}

DRAGQUEENMOD.ENABLEDPARTNERS = {
}

DRAGQUEENMOD.ENABLEDCHARMS = {
}



------------------------------
-- Custom objects
------------------------------



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
