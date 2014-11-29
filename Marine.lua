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
    self.target = self:get_closest_marine()
    return "advance"
end

function Marine:provide_steps(prev)
    if (prev) then return nil end

    print(dump(self:shortest_path_to_weapon()))

    -- if (self.target ~= nil) then
    --     print("moving!") 
    --     local targetEntity = Game.Map:get_entity(self.target)
    --     print(targetEntity.Bounds.X .. "," .. targetEntity.Bounds.Y)
    --     local path = Game.Map:get_move_path(self.marine_id, targetEntity.Bounds.X, targetEntity.Bounds.Y);
    --     print(dump(path))
    --     return { { Command = "move", Path = path }, { Command = "done" } }
    -- end

    return { { Command = "done" } }
end

function Marine:on_aiming(attack) end
function Marine:on_dodging(attack) end
function Marine:on_knockback(attack, entity) end

function Marine:shortest_path_to_weapon()
    local weapons = Game.Map:get_entities("w_")
    local thisMarine = self:get_marine()
    local numberOfWeapons = tablelength(weapons)

    if numberOfWeapons == 0 then
        print("no weapons")
        return {-1, -1}
    end

    local minPath = 1000
    local minInd = 0
    for i = 1, numberOfWeapons, 1 do
        local weaponBounds = weapons[i].Bounds
        local path = Game.Map:get_move_path(self.marine_id, weaponBounds.X, weaponBounds.Y)

        if tablelength(path) < minPath and tablelength(path) ~= 0 then
            minPath = tablelength(path)
            minInd = i
        end
    end

    return weapons[minInd].Bounds
end

function Marine:distance(entity_id)
    local enemy = Game.Map:get_entity(entity_id);
    local marine = Game.Map:get_entity(self.marine_id)
    local path = Game.Map:get_attack_path(self.marine_id, enemy.Bounds.X, enemy.Bounds.Y)
    -- print(dump(marine.Bounds), "   ", dump(enemy.Bounds))
    -- print("path: ", dump(path))
    return tablelength(path)
end

function Marine:get_closest_marine()
    local minPath = 9999
    local minInd = 9999
    for i = 1, #Marines, 1 do
        if (Marines[i].marine_id ~= self.marine_id) then
            local distance = self:distance(Marines[i].marine_id)
            if distance < minPath then
                minPath = distance
                minInd = i
            end
        end
    end
    if minInd < 9999 then
        return Game.Map:get_entity(Marines[minInd].marine_id)
    else
        print("no marines found")
        return nil
    end
end



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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
