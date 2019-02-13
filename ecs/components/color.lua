local Component = require("modules.concord.lib.component")

local Color = Component(function(e, color)
	e.color = color or {1, 1, 1, 1}
end)

local flags_tree = {"ImGuiTreeNodeFlags_DefaultOpen"}

function Color:debug()
	if imgui.TreeNodeEx("Color", flags_tree) then
		local r, g, b, a = unpack(self.color)
		local slider_r, slider_status_r = imgui.SliderFloat("R", r, 0, 1)
		local slider_g, slider_status_g = imgui.SliderFloat("G", g, 0, 1)
		local slider_b, slider_status_b = imgui.SliderFloat("B", b, 0, 1)
		local slider_a, slider_status_a = imgui.SliderFloat("A", a, 0, 1)
		self.color[1] = slider_r
		self.color[2] = slider_g
		self.color[3] = slider_b
		self.color[4] = slider_a
		imgui.TreePop()
	end
end

return Color
