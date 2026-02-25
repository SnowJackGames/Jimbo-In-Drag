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
local suitmap = {
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
    if not suitmap[suit] and not data.dragqueen_motherrank then
      suitmap[suit] = 0
    end
  end
else
  sendDebugMessage("Error defining suit map for Mothers; " ..
  "SMODS.Suits doesn't seem to be defined at this time for some reason", "Jimbo in Drag")
end



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
  nominal = 10,
  face = true,

  suit_map = suitmap,

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
