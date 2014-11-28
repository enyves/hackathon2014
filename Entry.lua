function CreateMarine(player_index, marine_id, instance_index)
    print("player_index: " .. player_index)
    print("marine_id: " .. marine_id)
    print("instance_index: " .. instance_index)
    return Marine:new(player_index, marine_id, instance_index)
end
