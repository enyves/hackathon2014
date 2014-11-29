Marine = class( "Marine", DeathMatchMarine )

function Marine:initialize(player_index, marine_id, instance_index)
    self.player_index = player_index
    self.marine_id = marine_id
    self.instance_index = instance_index
    self.hasWeapon = false
    self.weapon = nil
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
    local thisMarine = self:get_marine()

    if (not self.hasWeapon) then
        local localEntities = Game.Map:entities_at(thisMarine.Bounds.X, thisMarine.Bounds.Y);
        for i = 1, #localEntities do
            if (localEntities[i] ~= 0 and string.match(localEntities[i].Id, "^w_")) then
                self.hasWeapon = true
                print(self.marine_id .. " picked up a weapon: " .. localEntities[i].Id)
                print("=========", dump(localEntities[i]))
                self.weapon = localEntities[i]
                return { { Command = "pickup"}, {Command = "done"}}
            end 
        end
        local weaponBoundary = self:shortest_path_to_weapon()
        return { { Command = "move", Path = Game.Map:get_move_path(self.marine_id, weaponBoundary.X, weaponBoundary.Y) }, { Command = "done" } }
    else

        local closestMarine = self:get_closest_marine()
        if (closestMarine) then
            if (Game.Map:entity_has_los(self.marine_id, closestMarine.Bounds.X, closestMarine.Bounds.Y)) then
                print(self.marine_id .. " shooting at " .. closestMarine.Id) 
                print("weapon :: ", dump(self.weapon))
                return { 
                            { Command = "select_weapon", Weapon = self.weapon.Type }, 
                            { Command = "attack", Target = { X = closestMarine.Bounds.X, Y = closestMarine.Bounds.Y } },
                            { Command = "done" }
                        }
            else 
                return { { Command = "move", Path = Game.Map:get_attack_path(self.marine_id, closestMarine.Bounds.X, closestMarine.Bounds.Y) }, { Command = "done" } }
            end
        end
        
    end

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
    if enemy == nil then
        return 0
    end
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
            if distance < minPath and distance ~= 0 then
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


function Marine:when_other_marine_gotdamaged(other, event, prev)
    print("-===============")
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
