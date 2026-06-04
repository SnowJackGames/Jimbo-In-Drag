-- Jokers can be given attributes
-- https://github.com/Steamodded/smods/wiki/SMODS.Attributes

if not SMODS.Attribute then return nil end

SMODS.Attribute{
  key = "xmoney",
  alias = {
    "x_money"
  }
}

SMODS.Attribute{ -- scales based off of the current ante
  key = "xante",
  alias = {
    "x_ante"
  }
}

SMODS.Attribute{
  key = "debuff",
}

SMODS.Attribute{
  key = "slay",
}

SMODS.Attribute{
  key = "witch"
}

SMODS.Attribute{
  key = "accessorize"
}

SMODS.Attribute{
  key = "dragqueen",
  alias = {
    "drag_queen"
  }
}

SMODS.Attribute{
  key = "popstar",
  alias = {
    "pop_star"
  }
}

SMODS.Attribute{
  key = "dragqueen_kiss",
  alias = {
    "pop_star"
  }
}

------------------------------
-- Suits, Ranks
------------------------------

SMODS.Attribute{
  key = "dragqueen_purses",
}

SMODS.Attribute{
  key = "dragqueen_pumps",
}

SMODS.Attribute{
  key = "dragqueen_mother",
}

SMODS.Attribute{
  key = "light",
alias = {
  "light_suit",
  "lightsuit"
  }
}

SMODS.Attribute{
  key = "dark",
  alias = {
    "dark_suit",
    "darksuit"
  }
}

SMODS.Attribute{
  key = "nonplain",
  alias = {
    "non_plain"
  }
}

------------------------------
-- Cross-mod
------------------------------
-- Some Menthol / Minty's Silly Mod ones

SMODS.Attribute{ -- Effects that would be considered outside of a normal game
  key = "meta"
}

SMODS.Attribute{
  key = "kity",
  alias = {
      "kitty", "cat"
  }
}

SMODS.Attribute{
  key = "nonstandard"
}

SMODS.Attribute{ -- Cards which care about unscored cards
  key = "unscored"
}

SMODS.Attribute{
  key = "unix_crosses"
}

SMODS.Attribute{
  key = "paperback_apostle"
}