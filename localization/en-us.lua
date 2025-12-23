-- Use "color", not "colour" in our descriptions etc
-- UNLESS referring to a pre-existing named mechanic in us-en (such as us-en "Colour" Cards from the mod MoreFluff)
-- Mod's name "Drag Queen Balatro Mod" not final
-- Search for "placeholder" or "tempname" (any capitalization) for placeholder text
-- Avoid end-punctuation
-- Strings in double-quotes, not single quotes
-- in "misc{}", the localization table must follow the strict types outlined by Balatro's misc_functions.lua:function localize
-- but there's more flexibility with sets in "descriptions{}", as called with 
-- ex. localize{"name_text",key = "",set}

-- Colors implemented in lovely/colors.toml
    -- {C:hearts}
    -- {C:diamonds}
    -- {C:spades}
    -- {C:clubs}
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
    -- {C:black,E:1,S:1.1} for Ink
    -- {C:C:purple,E:1,S:1.1} for Color


return {
    descriptions = {
        Joker = {
            -- Modded jokers
            -- Patching vanilla jokers
            -- Patching other mods' jokers
        },
        Suit = {
            dragqueen_plain_suits = {
                name = "Plain suits",
                text = {
                    "{C:spades}Spades{}, {C:hearts}Hearts{},",
                    "{C:clubs}Clubs{} and {C:diamonds}Diamonds{}"
                }
            },
            dragqueen_accessory_suits = {
                name = "Accessory suits",
                text = {
                    "{C:dragqueen_purses}Purses{} and{C:dragqueen_pumps}Pumps{}"
                }
            },
            -- Implemented by Bunco
            -- Already has dark / light alignment
            dragqueen_bunco_exotic_suits = {
                name = "Exotic suits",
                text = {
                    "{C:bunc_halberds}Halberds{} and {C:bunc_fleurons}Fleurons{}"
                }
            },
            -- Implemented by Paperback
            -- Already has dark / light alignment
            dragqueen_paperback_proud_suits = {
                name = "Proud suits",
                text = {
                    "{C:paperback_crowns}Crowns{} and {C:paperback_stars}Stars{}"
                }
            },
            -- Implemented by Six Suits
            -- Giving them dark / light alignment
            dragqueen_six_night_suits = {
                name = "Night suits",
                text = {
                    "{C:six_moons}Moons{} and {C:six_stars}Stars{}"
                }
            },
            -- Implemented by Minty's Silly Little Mod
            -- 3s considered light by Paperback
            dragqueen_minty_treat_suit = {
                name = "Treat suit",
                text = {
                    "{C:minty_3s}3s{}"
                }
            },
            -- Implemented by Magic: The Jokering
            -- Not giving them a dark / light alignment
            dragqueen_mtg_magic_suits = {
                name = "Magic suits",
                text = {
                    "{C:clover}Clovers{} and {C:FFFFFF}Suitless{}"
                }
            },
            -- Implemented by Ink and Color
            -- giving them dark / light alignment
            dragqueen_ink_stained_suits = {
                name = "Stained suits",
                text = {
                    "{C:black,E:1,S:1.1}Ink{} and {C:purple,E:1,S:1.1}Color{}"
                }
            },
            -- When deck only has plain suits
            dragqueen_dark_suits_vanilla = {
                name = "Dark suits",
                text = {
                    "{C:spades}Spades{} and {C:clubs}Clubs{}"
                }
            },
            -- When deck has any non-plain suit
            dragqueen_dark_suits_vanilla_plus = {
                name = "Dark suits",
                text = {
                    "{C:spades}Spades{}, {C:clubs}Clubs{}"
                }
            },
            dragqueen_dark_suits_accessory = {
                name = "Accessory dark suits",
                text = {
                    "{C:dragqueen_purses}Purses{}"
                }
            },
            -- Bunco
            dragqueen_bunco_dark_exotic_suits = {
                name = "Exotic dark suits",
                text = {
                    "{C:bunc_halberds}Halberds{}"
                }
            },
            -- Paperback
            dragqueen_paperback_dark_suits_proud = {
                name = "Proud dark suits",
                text = {
                    "{C:paperback_crowns}Crowns{}"
                }
            },
            -- Six Suits
            dragqueen_six_dark_suits_night = {
                name = "Night dark suits",
                text = {
                    "{C:six_moons}Moons{}"
                }
            },
            -- Ink and Color
            dragqueen_ink_dark_suits_stained = {
                name = "Stained dark suits",
                text = {
                    "{C:black,E:1,S:1.1}Ink{}"
                }
            },
            -- When deck only has plain suits
            dragqueen_light_suits_vanilla = {
                name = "Light suits",
                text = {
                    "{C:hearts}Hearts{} and {C:diamonds}Diamonds{}"
                }
            },
            -- When deck has any non-plain suit
            dragqueen_light_suits_vanilla_plus = {
                name = "Light suits",
                text = {
                    "{C:hearts}Hearts{}, {C:diamonds}Diamonds{}"
                }
            },
            dragqueen_light_suits_accessory = {
                name = "Accessory light suits",
                text = {
                    "{C:dragqueen_pumps}Pumps{}"
                }
            },
            -- Bunco
            dragqueen_bunco_light_suits_exotic = {
                name = "Exotic light suits",
                text = {
                    "{C:bunc_fleurons}Fleurons{}"
                },
            },
            -- Paperback
            dragqueen_paperback_light_suits_proud = {
                name = "Proud light suits",
                text = {
                    "{C:paperback_stars}Stars{}"
                }
            },
            -- Six Suits
            dragqueen_six_light_suits_night = {
                name = "Night light suits",
                text = {
                    "{C:six_stars}Stars{}"
                }
            },
            -- Minty's Silly Little Mod
            dragqueen_minty_light_suits_treat = {
                name = "Treat light suits",
                text = {
                    "{C:minty_3s}3s{}"
                },
            },
            -- Ink and Color
            dragqueen_ink_light_suits_stained = {
                name = "Stained light suits",
                text = {
                    "{C:purple,E:1,S:1.1}Color{}"
                }
            }
        },
        Rank = {
        },
        Back = {
            b_dragqueen_suitplaceholder = {
                name = "Purses and Pumps Deck placeholder",
                text = {
                    "Start with a full set of Purses and Pumps, but no face cards"
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
        Planet = {
            c_dragqueen_quaoar = {
                name = "Quaoar",
            },
            c_dragqueen_haumea = {
                name = "Haumea",
            },
            c_dragqueen_sedna = {
                name = "Sedna",
            },
            c_dragqueen_makemake = {
                name = "Makemake",
            },
        },
        Tarot = {
        },
        Spectral = {
        },
        Voucher = {
            v_dragqueen_serve ={
                name = "Serve",
                text = "{C:dark_edition}Sparkle{}, {C:dark_edition}Gloss{}, and",
                "{C:dark_edition}Glitter{} cards",
                "appear {C:attention}#1#X{} more often"
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
            -- Given A...Z as nouns, and numbers being coordinators /conjunction
            -- [1]A[2]B... M[3]N[3]O...Y[4]Z[5]
            -- English for example, uses no coordinator at position [1], uses a comma and a space for position types [2] and [3]
            -- Position 4 being ", and ", no coordinator for position 5
            -- Russia does not use an oxford comma, so position 4 would be just " and "
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
            -- Between two final items in list, en-us using oxford comma
            dragqueen_suit_conjunction4 = {
                name = "Conjunction4",
                text = {
                    ", and "
                }
            },
            dragqueen_suit_conjunction5 = {
                name = "Conjunction5",
                text = {
                    ""
                }
            }
        },
    },
    misc = {
        dictionary = {
            -- Tooltip under cards
            k_dragqueen_joker = "Drag Queen",
            -- When a card says something like "Expired!"
            dragqueen_yas = "Yas!",
            dragqueen_slay = "Slay!"
            -- UI specific stuff like "Enable Cross-Mod Integration"
        },
        v_dictionary = {
            -- Variable information; like challenges_completed = "Completed#1#/#2# Challenges"
        },
        ranks = {
            dragqueen_mother = "Mother"
        },
        suits_singular = {
            dragqueen_pumps = "Pump",
            dragqueen_purses = "Purse"
        },
        suits_plural = {
            dragqueen_pumps = "Pumps",
            dragqueen_purses = "Purses"
        },
        poker_hands = {
            ["dragqueen_Spectrum"] = "Spectrum",
            ["dragqueen_Straight Spectrum"] = "Straight Spectrum",
            ["dragqueen_Straight Spectrum (Royal)"] = "Royal Spectrum",
            ["dragqueen_Spectrum House"] = "Spectrum House",
            ["dragqueen_Spectrum Five"] = "Spectrum Five",
        },
        poker_hand_descriptions = {
            ["dragqueen_Spectrum"] = {
                "5 cards with different suits"
            },
            ["dragqueen_Straight Spectrum"] = {
                "5 cards in a row (consecutive ranks),",
                "each with a different suit"
            },
            ["dragqueen_Spectrum House"] = {
                "A Three of a Kind and a Pair with",
                "each card having a different suit"
            },
            ["dragqueen_Spectrum Five"] = {
                "5 cards with the same rank,",
                "each with a different suit"
            }
        },
        labels = {
            -- Like how seals and editions have badges at the bottom
            dragqueen_sparkle = "Sparkle",
            dragqueen_glitter = "Glitter",
            dragqueen_gloss = "Gloss"
        }
    }
}