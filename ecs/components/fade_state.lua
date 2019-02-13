local Component = require("modules.concord.lib.component")

local FadeState = Component(function(e, state, duration)
	assert(type(state) == "string", "argument state must be a string")
	assert((state == "out") or (state == "in"), "argument state must either be out or in")
	assert(type(duration) == "number", "argument duration must be a number")
	e.state = state
	e.duration = duration
end)

function FadeState:debug()
	if imgui.TreeNodeEx("Fade State", __flags_tree) then
		imgui.Text("State: " .. self.state)
		imgui.Text("Duration: " .. self.duration)
		imgui.TreePop()
	end
end

return FadeState
