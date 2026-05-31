if DRAGQUEENMOD.config.decks_enabled then
  DRAGQUEENMOD.Sleeve {
    key = "accessory",
    deck_buff = "b_dragqueen_accessory",
    atlas = "sleeves",
    pos = { x = 0, y = 0 },
    dragqueen = {
      create_purses = true,
      create_pumps = true
    },
    unlocked = false,
    unlock_condition = { deck = "b_dragqueen_accessory", stake = "stake_green" },
    config = {
      remove_faces = true
    },
    loc_vars = function(self)
      return {
        key = self:loc_key(),
        vars = (not self:is_buffed()) and {
          DRAGQUEENMOD.easydescriptionslocalize("Other", "dragqueen_kissed")
        }
      }
    end,

    apply = function(self, sleeve)
      if self:is_buffed() then
        -- Apply Kiss and Polychrome to all Aces
        G.E_MANAGER:add_event(Event {
          func = function()
            for _, individual_card in ipairs(G.playing_cards or {}) do
              if individual_card:get_id() == 14 then
                individual_card:set_edition("e_polychrome", true, true)
                DRAGQUEENMOD.kiss_card(individual_card, true)
              end
            end
            return true
          end
        })
      end
    end
  }
end
