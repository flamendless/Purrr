local Component = require("modules.concord.lib.component")

local Sprite = Component(function(e, sprite, path)
	assert(sprite:type() == "Image", "Sprite must be an image")
	e.sprite = sprite
	e.path = path
end)

local sx = 0.5

function Sprite:debug()
	if imgui.TreeNodeEx("Sprite", __flags_tree) then
		local width, height = self.sprite:getDimensions()
		if self.path then
			imgui.Text("Path: " .. self.path)
		end
		imgui.Text("Size: " .. ("%ix%i"):format(width, height))
		sx = imgui.SliderFloat("Zoom", sx, 0.0, 1)
		imgui.Image(self.sprite, width * sx, height * sx)
		imgui.TreePop()
	end
end

return Sprite
