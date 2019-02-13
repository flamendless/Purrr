local Component = require("modules.concord.lib.component")

local Sprite = Component(function(e, sprite, path)
	assert(sprite:type() == "Image", "Sprite must be an image")
	e.sprite = sprite
	e.path = path
end)

local flags_tree = {"ImGuiTreeNodeFlags_DefaultOpen"}

function Sprite:debug()
	if imgui.TreeNodeEx("Sprite", flags_tree) then
		if self.path then
			imgui.Text("Path: " .. self.path)
		end
		if imgui.TreeNode("Texture") then
			imgui.Image(self.sprite, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
			imgui.TreePop()
		end
		imgui.TreePop()
	end
end

return Sprite
