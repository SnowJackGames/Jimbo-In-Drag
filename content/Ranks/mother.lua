-- The "Mother" rank is considered between any of Ace, King, Queen, and Jack for the purpose of straights
-- IN THE FUTURE, a TODO would be allowing Mothers to actually count as a King, Queen, and Jack once SMODS's\
-- Quantum Ranks are implemented

-- Example straights for mothers are like: A [M] K [M] Q [M] J [M] 10
-- Or A M M M 10
-- M M M M M is treated as a five of a kind instead of a straight
-- If we were sickos we could implement:
-- Straight House, Straight Four, Straight Five, Straight Flush House, Straight Flush Five,
-- Straight Specflush House, Straight Specflush Five

-- suitmap fallback code courtesy of Mintys Silly Mod

function DRAGQUEENMOD.mother_suit_map_set_up()
  DRAGQUEENMOD.mother_suitmap = {
    Fallback = 0,
    dragqueen_Purses = 1,
    dragqueen_Pumps = 2,
    Hearts = 3,
    Clubs = 4,
    Diamonds = 5,
    Spades = 6,
    paperback_Stars = 7,
    paperback_Crowns = 8,
    bunc_Fleurons = 9,
    bunc_Halberds = 10,
    minty_3s = 9
  }

  if SMODS.Suits then
    for suit, data in pairs(SMODS.Suits) do
      if not DRAGQUEENMOD.mother_suitmap[suit] and not data.dragqueen_motherrank then
        DRAGQUEENMOD.mother_suitmap[suit] = 0
      end
    end
  else
    sendDebugMessage("Error defining suit map for Mothers; " ..
    "SMODS.Suits doesn't seem to be defined at this time for some reason", "Jimbo in Drag")
  end
end

DRAGQUEENMOD.mother_suit_map_set_up()

SMODS.Rank {
  key = "Mother",
  card_key = "MOTHER",
  shorthand = "M",

  lc_atlas = "dragqueen_ranks_hc",
  hc_atlas = "dragqueen_ranks_hc",
  pos = { x = 1 },

  straight_edge = false,
  next = { "Ace", "King", "Queen", "Jack", "dragqueen_Mother" },
  prev = { "King", "Queen", "Jack", "10", "dragqueen_Mother" },
  strength_effect = {
    fixed = 14
  },
  prev_behavior = {
    fixed = 10
  },
  nominal = 10,
  face = true,

  suit_map = DRAGQUEENMOD.mother_suitmap,

  in_pool = function(self, args)
    -- Allows creating Mothers at the start of a run, like with a deck or sleeve
    if args and args.initial_deck and G.GAME.starting_params.dragqueen_spawn_mothers then
      return true
    end

    -- Allows forcing Mothers to be included
    if args and args.dragqueen and args.dragqueen.allow_mothers then
      return true
    end

    return false
  end
}

------------------------------
-- Vanilla fixes
------------------------------

-- Fixes so that if SMODS.modify_rank changes a card's rank, relationship with regards to Mothers work as intended

---@diagnostic disable: assign-type-mismatch
-- I don't know why strength_effect (and its equivalent prev_behavior) in SMODS.modify_rank works like this,
-- But entries in rank_data.prev and rank_data.next are strings like "King" etc
-- but strength_effect / prev_behavior requires being an integer. And fixed behavior only pulls
-- index 0 of .prev and .next.
-- See the patch in suits_and_ranks.toml, and
---@see SMODS.modify_rank

SMODS.Rank:take_ownership("Ace",
  {
    strength_effect = {
      fixed = "2"
    },
    prev_behavior = {
      fixed = "King"
    }
  }, true
)

SMODS.Rank:take_ownership("King",
  {
    strength_effect = {
      fixed = "Ace"
    },
    prev_behavior = {
      fixed = "Queen"
    }
  }, true
)

SMODS.Rank:take_ownership("Queen",
  {
    strength_effect = {
      fixed = "King"
    },
    prev_behavior = {
      fixed = "Jack"
    }
  }, true
)

SMODS.Rank:take_ownership("Jack",
  {
    strength_effect = {
      fixed = "Queen"
    },
    prev_behavior = {
      fixed = "10"
    }
  }, true
)

SMODS.Rank:take_ownership("10",
  {
    strength_effect = {
      fixed = "Jack"
    },
    prev_behavior = {
      fixed = "9"
    }
  }, true
)