local Component = require("modules.concord.lib.component")

local Animation = Component(function(e, obj)
	e.obj = obj
end)

local sx = 0.5

function Animation:debug()
	if imgui.TreeNodeEx("Animation", __flags_tree) then
		local width, height = self.obj:getDimension()
		local sheet_width, sheet_height = self.obj.image:getDimensions()
		imgui.Text("Path: " .. self.obj.json_path)
		imgui.Text("Size: " .. ("%ix%i"):format(width, height))
		imgui.Text("Sheet Size: " .. ("%ix%i"):format(sheet_width, sheet_height))
		sx = imgui.SliderFloat("Zoom", sx, 0.0, 1)
		imgui.Image(self.obj.image, self.obj.image:getWidth() * sx, self.obj.image:getHeight() * sx)
		imgui.TreePop()
	end
end

return Animation
