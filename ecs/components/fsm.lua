local Component = require("modules.concord.lib.component")

local FSM = Component(function(e, current_state, states)
	e.current_state = current_state
	e.previous_state = nil
	e.states = states
end)

return FSM
