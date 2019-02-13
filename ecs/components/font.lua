local Component = require("modules.concord.lib.component")

local Font = Component(function(e, font, path)
	assert(font:type() == "Font", "argument font must be a font")
	e.font = font
	e.path = path
end)

function Font:debug()
	if imgui.TreeNodeEx("Font", __flags_tree) then
		if self.path then
			imgui.Text("Path: " .. self.path)
		end
		imgui.TreePop()
	end
end

return Font
