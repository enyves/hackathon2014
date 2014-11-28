NoopMarine = class( "NoopMarine", DeathMatchMarine )

function NoopMarine:select_mode()
	return "advance"
end

function NoopMarine:provide_steps(prev)

	print("doing nothing: " .. self.player_index)

	return { { Command = "done" } }
end
