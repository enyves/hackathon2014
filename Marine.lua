Marine = class( "Marine", DeathMatchMarine )

function Marine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
    self.target = nil
end

function Marine:get_marine()
    return Game.Map:get_entity(self.marine_id);
end

function Marine:select_mode()
    --self.target = self:getClosest()
    return "advance"
end

function Marine:provide_steps(prev)
    if (prev) then return nil end

    print(dump(self:shortest_path_to_weapon()))

    -- return { { Command = "move", Path = Game.Map:get_move_path(self.marine_id, 10, 10) }, { Command = "done" } }
    return { Command = "done" }
--[[=======
    if (self.target ~= nil) then
        print("moving!") 
        local targetEntity = Game.Map:get_entity(self.target)
        print(targetEntity.Bounds.X .. "," .. targetEntity.Bounds.Y)
        local path = Game.Map:get_move_path(self.marine_id, targetEntity.Bounds.X, targetEntity.Bounds.Y);
        print(dump(path))
        return { { Command = "move", Path = path }, { Command = "done" } }
    end
    return { { Command = "done" } }
    
>>>>>>> Stashed changes--]]
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

    -- print(dump(weapons[minInd]))
    
    return weapons[minInd].Bounds
end

function Marine:distance(entity2_id) 
    local entity2 = Game.Map:get_entity(entity2_id)
    if (entity2 == nil) then 
        print ("Entity " .. entity2_id .. " not found!") 
        return 9999 
    end
    local steps = Game.Map:get_move_path(self.marine_id, entity2.Bounds.X, entity2.Bounds.Y)
    print(dump(steps));
    if (#steps == 0) then return 9999 end
    return #steps
end

function Marine:getClosest() 
    local closest = nil
    local closestDistance = 9999
    for i = 1, #Marines do
        if (Marines[i].marine_id ~= self.marine_id) then
            local distance = self:distance(Marines[i].marine_id)
            print("distance between " .. self.marine_id .. " and " .. Marines[i].marine_id .. " is " .. distance)
            if (closestDistance > distance) then
                closest = Marines[i].marine_id
                closestDistance = distance
            end            
        end
    end
    return closest
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
