-- Use "color", not "colour" in our descriptions etc
-- UNLESS referring to a pre-existing named mechanic in us-en (such as us-en "Colour" Cards from the mod MoreFluff)
-- Mod's name "Drag Queen Balatro Mod" not final
-- Search for "placeholder" or "tempname" (any capitalization) for placeholder text
-- Avoid end-punctuation
-- Strings in double-quotes, not single quotes
-- in "misc{}", the localization table must follow the strict types outlined by Balatro's misc_functions.lua:function localize
-- but there's more flexibility with sets in "descriptions{}", as called with
-- ex. localize{"name_text",key = "",set}
-- Capitalize tooltip text like a book title

-- Colors implemented in lovely/colors.toml
-- {C:spades}
-- {C:hearts}
-- {C:clubs}
-- {C:diamonds}
-- {C:attention}
-- {C:red}
-- {C:dragqueen_pumps}
-- {C:dragqueen_purses}
-- {C:bunc_fleurons}
-- {C:bunc_halberds}
-- {C:paperback_crowns}
-- {C:paperback_stars}
-- {C:six_moons}
-- {C:six_stars}
-- {C:minty_3s}
-- {C:clover}
-- {C:FFFFFF} for Suitless
-- {C:ink_inks}
-- {C:ink_colors}
-- {C:rgmc_goblets}
-- {C:rgmc_towers}
-- {C:rgmc_blooms}
-- {C:rgmc_daggers}
-- {C:rgmc_lanterns}
-- {C:rgmc_voids}
-- {C:unik_noughts}
-- {C:unik_crosses}
-- {C:dragqueen_keyword}



return {
  descriptions = {
    Joker = {
      -- Modded jokers
      j_dragqueen_broke_joker = {
        name = "Broke Joker",
        text = {
          "Played cards with",
          "{C:dragqueen_purses}Purse{} suit give",
          "{C:mult}+#1#{} Mult when scored",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_purses}Purses{} {C:attention}#2#{}"
        }
      },
      j_dragqueen_vain_joker = {
        name = "Vain Joker",
        text = {
          "Played cards with",
          "{C:dragqueen_pumps}Pump{} suit give",
          "{C:mult}+#1#{} Mult when scored",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_pumps}Pumps{} {C:attention}#2#{}"
        }
      },
      j_dragqueen_lipstick = {
        name = "Lipstick",
        text = {
          "{C:green}#1# in #2#{} chance for played",
          "cards with {C:dragqueen_purses}Purse{} suit to earn",
          "{X:money,C:white}X#3#{} {C:money}money{} when scored",
          "{s:0.8,C:inactive}(Max of {}{s:0.8,C:money}$#4#{}{s:0.8,C:inactive}){}",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_purses}Purses{} {C:attention}#5#{}"
        }
      },
      j_dragqueen_tights = {
        name = "Tights",
        text = {
          "{C:green}#1# in #2#{} chance for played",
          "cards with {C:dragqueen_pumps}Pump{} suit to give",
          "{X:chips,C:white}X#3#{} Chips when scored",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_pumps}Pumps{} {C:attention}#4#{}"
        }
      },
      j_dragqueen_shoes = {
        name = "Shoes",
        text = {
          "Costs {C:money}all your money{} {s:0.8,C:inactive}(up to {}{s:0.8,C:money}$300{}{s:0.8,C:inactive}){}",
          "If {C:attention}poker hand{} is a {C:attention}Pair{} of {C:dragqueen_pumps}Pumps{},",
          "earn {C:money}$#1#{}, then {C:green}#2# in #3#{} chance",
          "for scored cards to gain a random {C:dark_edition}Edition{}",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_pumps}Pumps{} {C:attention}#4#{}",
          "",
          "{s:0.8,C:inactive,E:1}\"#5#\"{}"
        },
        quote = {
          swear = {
            "I'm going to get what I want.",
            "Shoes.",
            "Shoes...",
            "Oh my god...",
            "Let's get some shoes.",
            "Oh my god, shoes.",
            "These shoes rule.",
            "These shoes suck.",
            "These shoes suck!",
            "Oh my godd, shoes.",
            "Shut up!",
            "Stupid boy.",
            "Let's party.",
            "These shoes are three hundred dollars.",
            "These shoes are three hundred fucking dollars.",
            "Let's get 'em!",
            "Oh.",
            "Oh, by the way bitch, fuck you!",
            "Fuck you!",
            "Those shoes are mine, betch",
            "Gimme those fucking shoes, betch.",
            "Betch."
          },
          no_swear = {
            "I'm going to get what I want.",
            "Shoes.",
            "Shoes...",
            "Oh my god...",
            "Let's get some shoes.",
            "Oh my god, shoes.",
            "These shoes rule.",
            "These shoes suck.",
            "These shoes suck!",
            "Oh my godd, shoes.",
            "Shut up!",
            "Stupid boy.",
            "Let's party.",
            "These shoes are three hundred dollars.",
            "These shoes are three hundred %$!#&^@ dollars.",
            "Let's get 'em!",
            "Oh.",
            "Oh, by the way, %$!# you!",
            "%$!# you!",
            "Those shoes are mine.",
            "Gimme those %$!#&^@ shoes."
          }
        }
      },
      j_dragqueen_tipsy_queen = {
        name = "Tipsy Queen",
        text = {
          "{C:attention}Glass Cards{} score an additional {X:mult,C:white}X#1#{},",
          "but always break if able to"
        }
      },
      j_dragqueen_dayjob_nightclub_a = {
        name = "Dayjob",
        text = {
          "Cards with a {C:dragqueen_light_suit}light suit{}",
          "give {C:chips}+#1#{} Chips per unique scoring",
          "{C:dragqueen_light_suit}light suit{} in hand when scored,",
          "and earn {C:money}$#2#{}"
        }
      },
      j_dragqueen_dayjob_nightclub_b = {
        name = "Nightclub",
        text = {
          "Cards with a {C:dragqueen_dark_suit}dark suit{}",
          "give {C:mult}+#3#{} Mult per unique scoring",
          "{C:dragqueen_dark_suit}dark suit{} in hand when scored,",
          "but cost {C:money}$#4#{} to do so",
          "{C:inactive,s:0.8}(Will not trigger if money is less than {C:money,s:0.8}$#4#{}"
        }
      },
      j_dragqueen_dayjob_nightclub_extra = {
        text = {
          "{C:inactive}On discard, flip this Joker{}"
        }
      },
      j_dragqueen_fishnets = {
        name = "Fishnets",
        text = {
          "Each card with",
          "{C:dragqueen_pumps}Pump{} suit held in hand",
          "gives {X:chips,C:white}X#1#{} Chips",
          "{C:white,X:dragqueen_keyword}Accessorize{} {C:dragqueen_pumps}Pumps{} {C:attention}#2#{}"
        }
      }
      -- Patching vanilla jokers
      -- Patching other mods' jokers
    },
    Rank = {
    },
    Back = {
      b_dragqueen_accessory = {
        name = "Accessory Deck",
        text = {
          "Start run with an",
          "additional full set of",
          "{C:dragqueen_purses}Purses{} and {C:dragqueen_pumps}Pumps{},",
          "but no {C:attention}face cards{}",
          "of any set"
        }
      },
      b_dragqueen_kissed = {
        name = "Kissed Deck",
        text = {
          "{C:attention}Attention!{} Placeholder Kissed Deck description"
        }
      },
      b_dragqueen_mother = {
        name = "Mother Deck placeholder",
        text = {
          "For each suit you start with, start with a Mother of that suit"
        }
      }
    },
    Blind = {
      -- Boss blinds
      bl_dragqueen_tempnamekissblind = {
        name = "The placeholder Kiss",
        text = {
          "Cards with Kisses",
          "are debuffed"
        }
      },
      b_dragqueen_rent = {
        name = "The Rent",
        text = {
          "If you have less than placeholder money,",
          "blind is {C:red}placeholder{} larger"
        }
      },
      b_dragqueen_gig = {
        name = "The Gig",
        text = {
          "All non-face cards",
          "are debuffed"
        }
      },
      -- #1# refers to "most played hand"
      b_dragqueen_lipsync = {
        name = "The Lipsync",
        text = {
          "Playing a hand other than a #1#",
          "sets score to zero"
        }
      }
      -- Showdown blinds
    },
    Challenge = {
    },
    Enhanced = {
    },
    Edition = {
    },
    Seal = {
    },
    Kiss = {
    },
    Sticker = {
    },
    Clip = {
    },
    Gemstone = {
    },
    Tarot = {
      c_dragqueen_purses_placeholder_plural = {
        name = "The Purses Placeholder",
        text = {
          "Converts up to",
          "{C:attention}#1#{} selected cards",
          "to {C:dragqueen_purses}Purses{}"
        }
      },
      c_dragqueen_purses_placeholder_singular = {
        name = "The Purses Placeholder",
        text = {
          "Converts up to",
          "{C:attention}#1#{} selected card",
          "to a {C:dragqueen_purses}Purse{}"
        }
      },
      c_dragqueen_pumps_placeholder_plural = {
        name = "The Pumps Placeholder",
        text = {
          "Converts up to",
          "{C:attention}#1#{} selected cards",
          "to {C:dragqueen_pumps}Pumps{}"
        }
      },
      c_dragqueen_pumps_placeholder_singular = {
        name = "The Pumps Placeholder",
        text = {
          "Converts up to",
          "{C:attention}#1#{} selected card",
          "to a {C:dragqueen_pumps}Pump{}"
        }
      },
    },
    Spectral = {
    },
    Voucher = {
      v_dragqueen_serve = {
        name = "Serve",
        text = {
          "{C:dark_edition}Sparkle{}, {C:dark_edition}Gloss{}, and",
          "{C:dark_edition}Glitter{} cards",
          "appear {C:attention}#1#X{} more often"
        }
      }
    },
    Pack = {
    },
    Tag = {
    },
    -- 45 Degree Tarot
    Rotarot = {
    },
    Colour = {
    },
    Sleeve = {

    },
    Partner = {

    },
    Charm = {

    },
    Grammar = {
      -- For suit-clarifying tooltips
      -- Making lists universal to different languages is hard
      -- https://linguistics.stackexchange.com/questions/17251/how-do-languages-other-than-english-form-lists-of-words
      -- Given A...Z as nouns, and numbers being coordinators /conjunction, some examples could include
      -- [1]A[2]B[4]C[5]
      -- [1]A[2]B[3]C[4]D[5]
      -- [1]A[2]B... M[3]N[3]O...Y[4]Z[5]
      -- English for example, uses no coordinator at position [1], uses a comma and a space for position types [2] and [3]
      -- Position [4] being ", and ", no coordinator for position [5]
      -- Russia does not use an oxford comma, so position [4] would be just " and "
      -- Additionally, position [4] can depend on the number of items in a list, so for languages like english that vary usage
      -- of a comma in a list of 2 there's conjunction4short
      -- This superfluous implementation *theoretically* makes translating this mod to say Classical Tibetan, Martuthunira, etc
      dragqueen_suit_conjunction1 = {
        name = "Conjunction1",
        text = {
          ""
        }
      },
      dragqueen_suit_conjunction2 = {
        name = "Conjunction2",
        text = {
          ", "
        }
      },
      dragqueen_suit_conjunction3 = {
        name = "Conjunction3",
        text = {
          ", "
        }
      },
      -- Between two final items in list with 3 or more, en-us using oxford comma
      dragqueen_suit_conjunction4 = {
        name = "Conjunction4",
        text = {
          ", and "
        }
      },
      -- Between two items in list of 2, for en-us doesn't use oxford comma
      dragqueen_suit_conjunction4short = {
        name = "Conjunction4short",
        text = {
          " and "
        }
      },
      dragqueen_suit_conjunction5 = {
        name = "Conjunction5",
        text = {
          ""
        }
      }
    },
    Other = {
      dragqueen_requires_jokers = {
        name = "Requires Jokers",
        text = {
          "Removed from pool due",
          "to {C:attention}Jokers{} being",
          "disabled in {C:legendary}Drag Queen Mod{}"
        }
      },
      dragqueen_requires_decks = {
        name = "Requires Decks",
        text = {
          "Removed from pool due",
          "to {C:attention}Decks{} being",
          "disabled in {C:legendary}Drag Queen Mod{}"
        }
      },
      dragqueen_requires_blinds = {
        name = "Requires Blinds",
        text = {
          "Removed from pool due",
          "to {C:attention}Blinds{} being",
          "disabled in {C:legendary}Drag Queen Mod{}"
        }
      },
      dragqueen_requires_skins = {
        name = "Requires Skins",
        text = {
          "Removed from pool due",
          "to {C:attention}Skins{} being",
          "disabled in {C:legendary}Drag Queen Mod{}"
        }
      },
      dragqueen_requires_cross_mods = {
        name = "Requires Cross-Mod Content",
        text = {
          "Removed from pool due",
          "to {C:attention}Cross-Mod Content{} being",
          "disabled in {C:legendary}Drag Queen Mod{}"
        }
      },
      
      dragqueen_plain_suits = {
        name = "Plain Suits",
        text = {
          "{C:spades}Spades{}, {C:hearts}Hearts{},",
          "{C:clubs}Clubs{} and {C:diamonds}Diamonds{}"
        }
      },
      dragqueen_accessory_suits = {
        name = "Accessory Suits",
        text = {
          "{C:dragqueen_purses}Purses{} and{C:dragqueen_pumps}Pumps{}"
        }
      },
      -- Implemented by Bunco
      -- Already has dark / light alignment
      dragqueen_bunc_exotic_suits = {
        name = "Exotic Suits",
        text = {
          "{C:bunc_halberds}Halberds{} and {C:bunc_fleurons}Fleurons{}"
        }
      },
      -- Implemented by Paperback
      -- Already has dark / light alignment
      dragqueen_paperback_proud_suits = {
        name = "Proud Suits",
        text = {
          "{C:paperback_crowns}Crowns{} and {C:paperback_stars}Stars{}"
        }
      },
      -- Implemented by Six Suits
      -- Giving them dark / light alignment
      dragqueen_six_night_suits = {
        name = "Night Suits",
        text = {
          "{C:six_moons}Moons{} and {C:six_stars}Stars{}"
        }
      },
      -- Implemented by Minty's Silly Little Mod
      -- 3s considered light by Paperback
      dragqueen_minty_treat_suit = {
        name = "Treat Suit",
        text = {
          "{C:minty_3s}3s{}"
        }
      },
      -- Implemented by Magic: The Jokering
      -- Not giving them a dark / light alignment
      dragqueen_mtg_magic_suits = {
        name = "Magic Suits",
        text = {
          "{C:clover}Clovers{} and {C:FFFFFF}Suitless{}"
        }
      },
      -- Implemented by Ink and Color
      -- giving them dark / light alignment
      dragqueen_ink_stained_suits = {
        name = "Stained Suits",
        text = {
          "{C:ink_inks}Inks{} and {C:ink_colors}Colors{}"
        }
      },
      -- Implemented by Madcap
      dragqueen_rgmc_parallel_suits = {
        name = "Parallel Suits",
        text = {
          "{C:rgmc_towers}Towers{}, {C:rgmc_goblets}Goblets{}, {C:rgmc_daggers}Daggers{}, and {C:rgmc_blooms}Blooms{}"
        }
      },
      dragqueen_rgmc_chaotic_suits = {
        name = "Chaotic Suits",
        text = {
          "{C:rgmc_lanterns}lanterns{} and {C:rgmc_voids}Voids{}"
        }
      },
      dragqueen_unik_tictactoe_suits = {
        name = "Tic Tac Toe Suits",
        text = {
          "{C:unik_noughts}Noughts{} and {C:unik_noughts}Crosses{}"
        }
      },
      dragqueen_accessory_dark_suits = {
        name = "Accessory Dark Suits",
        text = {
          "{C:dragqueen_purses}Purses{}"
        }
      },
      -- Bunco
      dragqueen_bunc_dark_suits = {
        name = "Exotic Dark Suits",
        text = {
          "{C:bunc_halberds}Halberds{}"
        }
      },
      -- Paperback
      dragqueen_paperback_dark_suits = {
        name = "Proud Dark Suits",
        text = {
          "{C:paperback_crowns}Crowns{}"
        }
      },
      -- Six Suits
      dragqueen_six_dark_suits = {
        name = "Night Dark Suits",
        text = {
          "{C:six_moons}Moons{}"
        }
      },
      -- Ink and Color
      dragqueen_ink_dark_suits = {
        name = "Stained Dark Suits",
        text = {
          "{C:ink_inks}Inks{}"
        }
      },
      --Madcap
      dragqueen_rgmc_dark_suits = {
        name = "Madcap Dark Suits",
        text = {
          "{C:rgmc_towers}Towers{}",
          "{C:rgmc_daggers}Daggers{}",
          "{C:rgmc_voids}Voids{}"
        }
      },
      dragqueen_unik_dark_suits = {
        name = "Unik Dark Suits",
        text = {
          "{C:unik_crosses}Crosses{}"
        }
      },
      dragqueen_accessory_light_suits = {
        name = "Accessory Light Suits",
        text = {
          "{C:dragqueen_pumps}Pumps{}"
        }
      },
      -- Bunco
      dragqueen_bunc_light_suits = {
        name = "Exotic Light Suits",
        text = {
          "{C:bunc_fleurons}Fleurons{}"
        },
      },
      -- Paperback
      dragqueen_paperback_light_suits = {
        name = "Proud Light Suits",
        text = {
          "{C:paperback_stars}Stars{}"
        }
      },
      -- Six Suits
      dragqueen_six_light_suits = {
        name = "Night Light Suits",
        text = {
          "{C:six_stars}Stars{}"
        }
      },
      -- Minty's Silly Little Mod
      dragqueen_minty_light_suits = {
        name = "Treat Light Suits",
        text = {
          "{C:minty_3s}3s{}"
        },
      },
      -- Magic: The Jokering
      dragqueen_mtg_light_suits = {
        name = "Magic Light Suits",
        text = {
          ""
        }
      },
      -- Ink and Color
      dragqueen_ink_light_suits = {
        name = "Stained Light Suits",
        text = {
          "{C:ink_colors}Colors{}"
        }
      },
      --Madcap
      dragqueen_rgmc_light_suits = {
        name = "Madcap Light Suits",
        text = {
          "{C:rgmc_goblets}Goblets{}",
          "{C:rgmc_blooms}Blooms{}",
          "{C:rgmc_lanterns}Lanterns{}"
        }
      },
      dragqueen_unik_light_suits = {
        name = "Unik Light Suits",
        text = {
          "{C:unik_noughts}Noughts{}"
        }
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.suit_tooltip()
      dragqueen_dark_suits_in_play_plain = {
        name = "Dark Suits",
        text = {
        }
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.suit_tooltip()
      dragqueen_light_suits_in_play_plain = {
        name = "Light Suits",
        text = {
        }
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.suit_tooltip()
      dragqueen_dark_suits_in_play_nonplain = {
        name = "Dark Suits",
        text = {
        }
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.suit_tooltip()
      dragqueen_light_suits_in_play_nonplain = {
        name = "Light Suits",
        text = {
        }
      },
      -- #1# is accessorize_count, #2# is relevant suit-converting tarot, #3# is suit color
      dragqueen_accessorize_tooltip = {
        name = "Accessorize",
        text = {
          "When obtained, creates {C:attention}#1#{}",
          "{C:#3#}#2#{}",
          "{s:0.8,C:inactive}(must have room){}"
        },
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.dragqueen_accessorize_tooltip()
      dragqueen_accessorize_tooltip_dynamic = {
        name = "Accessorize",
        text = {},
      },
      -- Dynamically generated through UI.lua:DRAGQUEENMOD.suit_to_consumable_table_tooltip()
      dragqueen_suit_to_consumable_table_tooltip_dynamic = {
        name = "Suit To Consumable Table",
        text = {},
      },
      -- dictionary tab
      dragqueen_dictionary_accessorize = {
        name = "Accessorize",
        text = {
          "{s:0.9}When this item is obtained, create{}",
          "{s:0.9}up to {}{C:attention,s:0.9}X{}{s:0.9} number of the{}",
          "{s:0.9}associated {}{C:attention,s:0.9}consumable{}{s:0.9} on the{}",
          "{C:attention,s:0.9}\"Suit To Consumable Table\"{}",
          "{s:0.9}for that {}{C:attention,s:0.9}suit{}{s:0.9} if you have room; i.e.{}",
          "{s:0.9}\"{}{C:white,X:dragqueen_keyword,s:0.9}Accessorize{}{s:0.9} {}{C:hearts,s:0.9}Hearts{}{s:0.9} {}{C:attention,s:0.9}1{}{s:0.9}\" creates{}",
          "{s:0.9}up to {}{C:attention,s:0.9}1{}{s:0.9} {}{C:tarot,s:0.9}The Sun{}",
          "{C:inactive}---{}",
          "{s:0.9}\"{}{C:white,X:dragqueen_keyword,s:0.9}Accessorize{}{s:0.9} Random {}{C:attention,s:0.9}X{}{s:0.9}\" instead{}",
          "{s:0.9}creates {}{C:attention,s:0.9}X{}{s:0.9} random {}{C:attention,s:0.9}consumables{}{s:0.9} from the{}",
          "{s:0.9}{}{C:attention,s:0.9}\"Suit To Consumable Table\"{}",
        }
      },
      dragqueen_dictionary_slay = {
        name = "Slay",
        text = {
          "mrowwwww"
        }
      }
    }
  },
  misc = {
    dictionary = {
      -- Tooltip under cards
      k_dragqueen_joker = "Drag Queen",
      k_dragqueen_shoes_rule = "Rule!",
      k_dragqueen_shoes_suck = "Suck!",
      -- When a card says something like "Expired!"
      dragqueen_yas = "Yas!",
      dragqueen_slay = "Slay!",
      -- Config menu stuff
      dragqueen_ui_jokers_enabled = "Enable Jokers",
      dragqueen_ui_decks_enabled = "Enable Decks",
      dragqueen_ui_blinds_enabled = "Enable Blinds",
      dragqueen_ui_skins_enabled = "Enable Skins",
      dragqueen_ui_vanilla_reworks_enabled = "Enable Vanilla Reworks",
      dragqueen_ui_cross_mod_enabled = "Enable Cross-Mod Content",
      dragqueen_ui_swears_enabled = "Enable Swears",
      dragqueen_ui_requires_restart = "Requires Restart",
      dragqueen_ui_does_not_require_restart = "Does Not Require Restart",
      dragqueen_ui_dictionary = "Dictionary",
      dragqueen_ui_suit_to_consumable_table = "Suit to Consumable Table",
      dragqueen_ui_suit_to_consumable_table_suit = "Suit",
      dragqueen_ui_suit_to_consumable_table_consumable = "Consumable",
      dragqueen_ui_suit_to_consumable_table_and_more = "...And #1# more unlisted entries",


      dragqueen_card_badge_dark_suit = "Dark Suit",
      dragqueen_card_badge_light_suit = "Light Suit",
      dragqueen_card_badge_dark_and_light_suit = "Dark and Light Suit",
      dragqueen_card_badge_plain_suit = "Plain Suit",
      dragqueen_card_badge_accessory_suit = "Accessory Suit",
      dragqueen_card_badge_bunc_exotic_suit = "Exotic Suit",
      dragqueen_card_badge_paperback_proud_suit = "Pride Suit",
      dragqueen_card_badge_six_night_suit = "Night Suit",
      dragqueen_card_badge_minty_treat_suit = "Treat Suit",
      dragqueen_card_badge_mtg_magic_suit = "Magic Suit",
      dragqueen_card_badge_ink_stained_suit = "Stained Suit",
      dragqueen_card_badge_rgmc_parallel_suit = "Parallel Suit",
      dragqueen_card_badge_rgmc_chaotic_suit = "Chaotic Suit",
      dragqueen_card_badge_unik_tictactoe_suit = "Tic Tac Toe Suit",

      dragqueen_dayjob_nightclub_a = "Dayjob",
      dragqueen_dayjob_nightclub_b = "Nightclub",
    },
    v_dictionary = {
      -- Variable information; like challenges_completed = "Completed#1#/#2# Challenges"
    },
    ranks = {
      dragqueen_mother = "Mother"
    },
    suits_singular = {
      dragqueen_Pumps = "Pump",
      dragqueen_Purses = "Purse",
      bunc_Fleurons = "Fleuron",
      bunc_Halberds = "Halberd",
      paperback_Crowns = "Crown",
      paperback_Stars = "Star",
      minty_3s = "3",
      six_Moons = "Moon",
      six_Stars = "Star",
      ink_Inks = "Ink",
      ink_Colors = "Color"
    },
    suits_plural = {
      dragqueen_Pumps = "Pumps",
      dragqueen_Purses = "Purses",
      bunc_Fleurons = "Fleurons",
      bunc_Halberds = "Halberds",
      paperback_Crowns = "Crowns",
      paperback_Stars = "Stars",
      minty_3s = "3s",
      six_Moons = "Moons",
      six_Stars = "Stars",
      ink_Inks = "Inks",
      ink_Colors = "Colors"
    },
    labels = {
      -- Like how seals and editions have badges at the bottom
      dragqueen_sparkle = "Sparkle",
      dragqueen_glitter = "Glitter",
      dragqueen_gloss = "Gloss"
    }
  }
}
