local Component = require("modules.concord.lib.component")

local Sprite = Component(function(e, sprite)
	assert(sprite:type() == "Image", "Sprite must be an image")
	e.sprite = sprite
	e.original_width = sprite:getWidth()
	e.original_height = sprite:getHeight()
end)

local show_image = false
local window_id = (show_image == false) and "Show Image Viewer" or "Hide Image Viewer"

function Sprite:debug()
	if imgui.TreeNode("Sprite") then
		imgui.SameLine()
		if imgui.SmallButton(window_id) then
			show_image = not show_image
			window_id = (show_image == false) and "Show Image Viewer" or "Hide Image Viewer"
		end
		imgui.TreePop()
	end
	if show_image then
		self:image_viewer()
	end
end

function Sprite:image_viewer()
	imgui.Begin("Image Viewer", nil, ImGuiWindowFlags_AlwaysAutoResize)
	imgui.Image(self.sprite, self.original_width, self.original_height)
	imgui.Separator()
	imgui.Text("Size: " .. ("%ix%i"):format(self.original_width, self.original_height))
	imgui.End()
end

return Sprite
