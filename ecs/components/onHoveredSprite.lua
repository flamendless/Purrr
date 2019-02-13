local Component = require("modules.concord.lib.component")

local onHoveredSprite = Component(function(e, sprite, path)
	assert(sprite:type() == "Image", "sprite must be an image")
	e.sprite = sprite
	e.path = path
	e.isActive = false
end)

local sx = 0.5

function onHoveredSprite:debug()
	if imgui.TreeNodeEx("onHoveredSprite", __flags_tree) then
		local width, height = self.sprite:getDimensions()
		imgui.Text("isActive: " .. tostring(self.isActive))
		if self.path then
			imgui.Text("Path: " .. self.path)
		end
		imgui.Text("Size: " .. ("%ix%i"):format(width, height))
		sx = imgui.SliderFloat("Zoom", sx, 0.0, 1)
		imgui.Image(self.sprite, width * sx, height * sx)
		imgui.TreePop()
	end
end

return onHoveredSprite
