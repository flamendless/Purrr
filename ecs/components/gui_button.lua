local Component = require("modules.concord.lib.component")

local GUIButton = Component(function(e, isActive)
	e.state = {
		isActive = (isActive == false) or true,
		isEntered = false,
		isClicked = false,
	}
end)

function GUIButton:debug()
	if imgui.TreeNodeEx("GUI Button", __flags_tree) then
		imgui.Text("isActive: " .. tostring(self.state.isActive))
		imgui.Text("isEntered: " .. tostring(self.state.isEntered))
		imgui.Text("isClicked: " .. tostring(self.state.isClicked))
		imgui.TreePop()
	end
end

return GUIButton
