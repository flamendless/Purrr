local Component = require("modules.concord.lib.component")

local FadeState = Component(function(e, state, duration)
	assert(type(state) == "string", "argument state must be a string")
	assert((state == "out") or (state == "in"), "argument state must either be out or in")
	assert(type(duration) == "number", "argument duration must be a number")
	e.state = state
	e.duration = duration
end)

return FadeState
