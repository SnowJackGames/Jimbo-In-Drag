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
  ------------------------------
  -- Initials, assertions
  ------------------------------
  assert(type(cards) == "table" or "Card",
    "DRAGQUEENMOD.convert_cards_to handed that which is not a Card or table of cards")
  assert(type(attribute_table) == "table",
    "DRAGQUEENMOD.convert_cards_to handed \"attribute_table\" of wrong type")
  assert(type(flip) == "boolean" or "nil",
    "DRAGQUEENMOD.convert_cards_to handed \"flip\" of wrong type")
  assert(type(immediate) == "boolean" or "nil",
    "DRAGQUEENMOD.convert_cards_to handed \"immediate\" of wrong type")
  assert(type(set_delay) == "number" or "nil",
    "DRAGQUEENMOD.convert_cards_to handed \"set_delay\" of wrong type")

  local shouldflip = flip or nil
  local shouldimmediate = immediate or false
  local shoulddelay = set_delay or nil
  local sound = attribute_table.sound or "tarot1"
  if not cards then return end
  if cards and cards.is and cards:is(Card) then cards = {cards} end

  ------------------------------
  -- Initial Sounds and Flips
  ------------------------------

  for i = 1, #cards do
    -- For attribute changes without sounds / juice_up, we implement that for them
    if attribute_table.suit_conv or
    attribute_table.rank_conv or
    attribute_table.enhancement_conv or
    attribute_table.bonus_chips then
      local initial_sound_and_juice = function()
        play_sound(sound)
        cards[i]:juice_up(0.3, 0.5)
      end

      DRAGQUEENMOD.conversion_event_helper(initial_sound_and_juice, 0.4)
    end

    -- Then flip down
    if shouldflip then
      -- raises in pitch
      local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
      local flip_event = function ()
        cards[i]:flip()
        play_sound("card1", percent)
        cards[i]:juice_up(0.3, 0.3)
      end

      DRAGQUEENMOD.conversion_event_helper(flip_event, 0.15)
    end
  end

  ------------------------------
  -- Changing Attributes
  ------------------------------

  for i = 1, #cards do
    -- Does NOT automatically juice / make sounds
    if attribute_table.suit_conv or attribute_table.rank_conv then
      local suit_or_rank_change = function()
        cards[i] = SMODS.change_base(cards[i], attribute_table.suit_conv, attribute_table.rank_conv)
      end
      DRAGQUEENMOD.conversion_event_helper(suit_or_rank_change, shoulddelay, shouldimmediate)
    end

    -- Does NOT automatically juice / make sounds
    if attribute_table.enhancement_conv then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_ability(G.P_CENTERS[attribute_table.enhancement_conv]) end, shoulddelay, shouldimmediate)
    end

    -- Automatically DOES juicing and sounds
    if attribute_table.edition then
      local edition_override = attribute_table.edition_override or false
      if edition_override == true then
        DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_edition(attribute_table.edition, true) end, shoulddelay, shouldimmediate)
      else
        local check_edition_first = function()
          if not cards[i].edition then
            cards[i]:set_edition(attribute_table.edition, true)
          end
        end
        DRAGQUEENMOD.conversion_event_helper(check_edition_first, shoulddelay, false)
      end
    end

    -- Automatically DOES juicing and sounds
    if attribute_table.seal then
      DRAGQUEENMOD.conversion_event_helper(function() cards[i]:set_seal(attribute_table.seal, nil, true) end, shoulddelay, shouldimmediate)
    end

    -- Does NOT automatically juice / make sounds
    if attribute_table.bonus_chips then
      local bonus_add = function()
        cards[i].ability.perma_bonus = cards[i].ability.perma_bonus or 0
        cards[i].ability.perma_bonus = cards[i].ability.perma_bonus + attribute_table.bonus_chips
      end
      DRAGQUEENMOD.conversion_event_helper(bonus_add, shoulddelay, shouldimmediate)
    end

    -- Can set up other attributes of a card we want to modify

  end

  ------------------------------
  -- End sounds and flips
  ------------------------------

  for i = 1, #cards do
    -- Then flip back up
    if shouldflip then
      -- raises in pitch
      local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
      local flip_and_finish_event = function ()
        cards[i]:flip()
        play_sound("card1", percent)
        cards[i]:juice_up(0.3, 0.3)

        -- Update the sprites of cards
        if cards[i].config and cards[i].config.center then
          cards[i]:set_sprites(cards[i].config.center)
        end
        if cards[i].ability then
          cards[i].front_hidden = cards[i]:should_hide_front()
        end
      end

      DRAGQUEENMOD.conversion_event_helper(flip_and_finish_event, 0.15)
    else
      local finish_event = function ()
        cards[i]:juice_up(0.3, 0.3)

        -- Update the sprites of cards
        if cards[i].config and cards[i].config.center then
          cards[i]:set_sprites(cards[i].config.center)
        end
        if cards[i].ability then
          cards[i].front_hidden = cards[i]:should_hide_front()
        end
      end

      DRAGQUEENMOD.conversion_event_helper(finish_event, 0.15)
    end
  end

  ------------------------------
  -- Unhighlight
  ------------------------------

  local unhighlight = function()
    G.hand:unhighlight_all()
  end

  DRAGQUEENMOD.conversion_event_helper(unhighlight, 0.2)
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



-- Attempts to create a consumable that converts cards to the inputted suit
---@param suit string If `random`, then it gives a random suit-converting consumable card (see 'cross-mods.lua')
---@param count integer
---@param saveroom? integer info: 
-- In case space needs to be reserved, like if this effect was generated by
-- something about to enter the consumables zone.
function DRAGQUEENMOD.accessorize(suit, count, saveroom)
  local consumable = ""
  local reservespace = saveroom or 0
  
  -- To get a random suit consumable in our table, we have to iterate to find the length,
  -- determine a random position, then iterate again until we can retrieve the suit
  -- at that position
  local function random_consumable_suit()
    local length = 0
    for _, _ in pairs(DRAGQUEENMOD.suits_to_consumable) do
      length = length + 1
    end
    local current_position = 1
    local randomed_position = math.random(length)
    for _, v in pairs(DRAGQUEENMOD.suits_to_consumable) do
      if current_position == randomed_position then consumable = v end
      current_position = current_position + 1
    end
    return consumable
  end

  if suit ~= "random" then
    consumable = assert(DRAGQUEENMOD.suits_to_consumable[suit], tostring(suit) .. " not found in DRAGQUEENMOD.suits_to_consumable")
  end

  for i = 1, count, 1 do
    if suit == "random" then
      consumable = random_consumable_suit()
    end

    DRAGQUEENMOD.try_spawn_card({ key = consumable }, reservespace)
  end
end



-- Sets `card.ability.dragqueen_kissed = true` for a given `card`
-- <br>works with Balatro's event system 
---@param card Card|table
function DRAGQUEENMOD.kiss_card(card)
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.15, func = function()
    play_sound("tarot1")
    card.ability.dragqueen_kissed = true
    card:juice_up(0.3, 0.5)
    return true
  end })
  G.E_MANAGER:add_event(Event { trigger = "before", delay = 0.1, func = function()
    play_sound("tarot2", 0.85, 0.6)
    return true
  end })
end
