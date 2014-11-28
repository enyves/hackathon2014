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
    print("select_mode called")
    return "advance"
end

function Marine:provide_steps(prev)
    print("provide steps called " )

    Marine:out()

    return { { Command = "move", Path = Game.Map:get_move_path(self.marine_id, 10, 10) }, { Command = "done" } }
end

function Marine:on_aiming(attack) end
function Marine:on_dodging(attack) end
function Marine:on_knockback(attack, entity) end

function Marine:out()
    local marine, err = Game.Map:get_entity(self.marine_id)
    if (marine == nil) then print (err) end
    for key,value in ipairs(marine) do print(key,value) end
end