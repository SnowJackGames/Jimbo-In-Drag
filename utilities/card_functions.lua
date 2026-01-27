-- Functions that spawn or affect cards (Jokers, consumables, playing cards)



--- Tries to spawn a Joker, Consumable, or Playing Card, ensuring
--- that there is space available, using the respective buffer.
--- <br><b>Does not take into account any other areas.</b><br>
--- @param args CreateCard | { card: Card?, strip_edition: boolean? } | { instant: boolean?, func: function? } info:
--- Either a table passed to `SMODS.create_card`, which will create a new card,
--- Or a table with `card`, which will copy the passed card and remove its edition based on `strip_edition`.
--- @param saveroom? integer info:
--- If slots (in consumables or jokers) need to be reserved (for perhaps something immediately spawning in the slot afterwards)
--- @return boolean -- If the card was able to spawn or not
--- Thanks Paperback
function DRAGQUEENMOD.try_spawn_card(args, saveroom)
  -- As best that we can, let's prevent code from spilling through SMODS.add_card, temp_create_card, get_current_pool etc
  assert(args.set or args.key or args.card or args.area or args.front or args.rank or args.suit, "missing minimum info for DRAGQUEENMOD.try_spawn_card()")
  if args.key and G.P_CENTERS[args.key] == nil then
    error("Could not find args.key " .. tostring(args.key) .. " in G.P_CENTERS")
  end

  local is_joker = DRAGQUEENMOD.is_joker(args.card, args.set, args.key)
  local is_playing_card = DRAGQUEENMOD.is_playing_card(args.set, args.front, args.rank, args.suit)
  local is_consumable = DRAGQUEENMOD.is_consumable(args.set, args.key)
  local setsaveroom = saveroom or 0

    -- It has to be one of three
  if not (is_joker or is_playing_card or is_consumable) then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is considered neither a joker, playing card, nor consumable")
  end

  if is_joker and is_playing_card and is_consumable then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is considered a joker, playing card, and consumable all at once")
  end

  if is_joker and is_playing_card then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is considered both a joker and a playing card")
  end

  if is_joker and is_consumable then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is considered both a joker and a consumable")
  end

  if is_playing_card and is_consumable then
    error("DRAGQUEENMOD.try_spawn_card() called to create that which is considered both a playing card and a consumable")
  end

  -- Determine the relevant area and buffer where a thing will spawn
  -- Pulls from Balatro code, so "consumable" here spelt with an "e"
  local area = nil
  local buffer = nil
  
  if is_joker == true then
    area = G.jokers
    buffer = "joker_buffer"
  end

  if is_consumable == true then
    area = G.consumeables
    buffer = "consumeable_buffer"
  end

  -- Notice about key / set handling by create_card() 
  if args.key and (args.set == "Base") and (args.key ~= "c_base") then
    print("Warning: Attempting to spawn a base card with an incompatible key, create_card() will ignore key")
  end

  local should_spawn = false
  if is_playing_card then should_spawn = true
  else
    if not (area) then
      error("DRAGQUEENMOD.try_spawn_card() can't spawn joker or consumable without an area, or can't reach G.jokers or G.consumeables")
    else
      if is_joker and ((#area.cards + G.GAME["joker_buffer"] + setsaveroom) < area.config.card_limit) then should_spawn = true end
      if is_consumable and ((#area.cards + G.GAME["consumeable_buffer"] + setsaveroom) < (area.config.card_limit)) then should_spawn = true end
    end
  end

  -- If it's a playing card we don't have to worry about consumable or joker slots
  if should_spawn then
    local added_card
    local function add()
      if args.card and area then
        added_card = copy_card(args.card, nil, nil, nil, args.strip_edition)
        added_card:add_to_deck()
        area:emplace(added_card)
      else
        added_card = SMODS.add_card(args)
      end
    end
    
    if args.instant then
      add()
    else
      -- If there is a relevant buffer, then we increase it
      if buffer then
        G.GAME[buffer] = G.GAME[buffer] + 1

        G.E_MANAGER:add_event(Event {
          func = function()
            add()
            G.GAME[buffer] = 0
            return true
          end
        })
      end
    end

    if args.func and type(args.func) == "function" then
      args.func(added_card)
    end

    return true
  else
    return false
  end
end



-- Convert attributes of a card; code thanks to Pokermon
-- <br> Could be the effects of a consumable, a joker, etc
---@param cards Card|table Card(s) you're modifing
---@param attribute_table table How you want the card(s) to change
---@param flip? boolean If the card should flip, default to false
---@param immediate? boolean If it should happen without delay, default to false
---@param set_delay? number in seconds (affected by game speed)
function DRAGQUEENMOD.convert_cards_to(cards, attribute_table, flip, immediate, set_delay)
  local shouldflip = flip or false
  local shouldimmediate = immediate or false
  local shoulddelay = set_delay or nil
  if not cards then return end
  if cards and cards.is and cards:is(Card) then cards = {cards} end
  for i = 1, #cards do
    if shouldflip then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:flip() end, 0.2)
    end

    if attribute_table.enhancement_conv then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_ability(G.P_CENTERS[attribute_table.enhancement_conv]) end, shoulddelay, shouldimmediate)
    end
    if attribute_table.edition then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_edition(attribute_table.edition, true) end, shoulddelay, shouldimmediate)
    end
    if attribute_table.suit_conv then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:change_suit(attribute_table.suit_conv) end, shoulddelay, shouldimmediate)
    end
    if attribute_table.seal then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_seal(attribute_table.seal, nil, true) end, shoulddelay, shouldimmediate)
    end
    if attribute_table.bonus_chips then
      local bonus_add = function()
        cards[i].ability.perma_bonus = cards[i].ability.perma_bonus or 0
        cards[i].ability.perma_bonus = cards[i].ability.perma_bonus + attribute_table.bonus_chips
      end
      DRAGQUEENMOD.conversion_event_helper(bonus_add, shoulddelay, shouldimmediate)
    end
    -- Can set up other attributes of a card we want to modify
  end
  if flip then delay(0.3) end
  if cards == G.hand.highlighted then
    DRAGQUEENMOD.conversion_event_helper(function() G.hand:unhighlight_all() end)
  end
end



-- Helps `DRAGQUEENMOD.convert_cards_to()` function interface functions of cards
---@param func function Ex. `Card:flip()`, `Card:juice_up()`,`Card:set_edition()`, etc
---@param set_delay? number In seconds (affected by game speed)
---@param immediate? boolean Run function immediately if true, otherwise pass to `add_event` with delay (default 0.5)
function DRAGQUEENMOD.conversion_event_helper(func, set_delay, immediate)
  local shouldimmediate = immediate or false
  if shouldimmediate then
    func()
  else
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = set_delay or 0.5,
      func = function()
        func()
        return true
      end
    }))
  end
end



-- Attempts to create a tarot that converts cards to the inputted suit
---@param suit string If `random`, then it gives a random suit-converting tarot card (see 'cross-mods.lua')
---@param count integer
---@param saveroom? integer info: 
-- In case space needs to be reserved, like if this effect was generated by
-- something about to enter the consumables zone.
function DRAGQUEENMOD.accessorize(suit, count, saveroom)
  local tarot = ""
  local reservespace = saveroom or 0
  
  -- To get a random suit tarot in our table, we have to iterate to find the length,
  -- determine a random position, then iterate again until we can retrieve the suit
  -- at that position
  local function random_tarot_suit()
    local length = 0
    for _, _ in pairs(DRAGQUEENMOD.suits_to_tarot) do
      length = length + 1
    end
    local current_position = 1
    local randomed_position = math.random(length)
    for _, v in pairs(DRAGQUEENMOD.suits_to_tarot) do
      if current_position == randomed_position then tarot = v end
      current_position = current_position + 1
    end
    return tarot
  end

  if suit ~= "random" then
    tarot = assert(DRAGQUEENMOD.suits_to_tarot[suit], tostring(suit) .. " not found in DRAGQUEENMOD.suits_to_tarot")
  end

  for i = 1, count, 1 do
    if suit == "random" then
      tarot = random_tarot_suit()
    end

    DRAGQUEENMOD.try_spawn_card({ key = tarot }, reservespace)
  end
end