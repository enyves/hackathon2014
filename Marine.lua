Marine = class( "Marine", DeathMatchMarine )

function Marine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
end

function Marine:get_marine()
    return Game.Map:get_entity(self.marine_id);
end

function Marine:select_mode()
    return "advance"
end

function Marine:provide_steps(prev)

    local weapons, err = Game.Map:get_entities("w_")
    print(dump(weapons))

    -- return { { Command = "move", Path = Game.Map:get_move_path(self.marine_id, 10, 10) }, { Command = "done" } }
    return { Command = "done" }
end

function Marine:on_aiming(attack) end
function Marine:on_dodging(attack) end
function Marine:on_knockback(attack, entity) end


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end