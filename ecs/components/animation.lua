local Component = require("modules.concord.lib.component")

local Animation = Component(function(e, obj)
	e.obj = obj
end)

local show_image = false
local window_id = (show_image == false) and "Show Animation Viewer" or "Hide Animation Viewer"

function Animation:debug()
	if imgui.TreeNode("Animation") then
		imgui.SameLine()
		if imgui.SmallButton(window_id) then
			show_image = not show_image
			window_id = (show_image == false) and "Show Animation Viewer" or "Hide Animation Viewer"
		end
		imgui.TreePop()
	end
	if show_image then
		self:image_viewer()
	end
end

function Animation:image_viewer()
	imgui.Begin("Animation Viewer", nil, ImGuiWindowFlags_AlwaysAutoResize)
	local width, height = self.obj:getDimension()
	local sheet_width, sheet_height = self.obj.image:getDimensions()
	imgui.Image(self.obj.image, self.obj.image:getWidth(), self.obj.image:getHeight())
	imgui.Separator()
	imgui.Text("Path: " .. self.obj.json_path)
	imgui.Text("Size: " .. ("%ix%i"):format(width, height))
	imgui.Text("Sheet Size: " .. ("%ix%i"):format(sheet_width, sheet_height))
	imgui.End()
end

return Animation
