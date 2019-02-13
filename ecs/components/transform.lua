local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local Transform = Component(function(e, pos, rotation, sx, sy, ox, oy, kx, ky)
	assert(vec2.isvector(pos), "pos must be a vector object")
	e.pos = pos
	e.rotation = rotation or 0
	e.sx = sx or 1
	e.sy = sy or 1
	e.ox = ox or 0
	e.oy = oy or 0
	e.kx = kx or 0
	e.ky = ky or 0
end)

local flags_tree = {"ImGuiTreeNodeFlags_DefaultOpen"}
local rad = math.rad
local rad_360 = rad(360)

function Transform:debug()
	if imgui.TreeNodeEx("Position", flags_tree) then
		local x, status_x = imgui.SliderInt("x", self.pos.x, 0, love.graphics.getWidth())
		local y, status_y = imgui.SliderInt("y", self.pos.y, 0, love.graphics.getHeight())
		local rotation, status_rotation = imgui.SliderInt("rotation", self.rotation, 0, rad_360)
		local sx, status_sx = imgui.SliderInt("sx", self.sx, 0, 10)
		local sy, status_sy = imgui.SliderInt("sy", self.sy, 0, 10)
		imgui.Text("Offset X: " .. self.ox)
		imgui.Text("Offset Y: " .. self.oy)
		if imgui.TreeNode("Original") then
			imgui.Text("Position X: " .. self.pos.x - self.ox)
			imgui.Text("Position Y: " .. self.pos.y - self.oy)
			imgui.TreePop()
		end
		if status_x or status_y then
			self.pos.x = x
			self.pos.y = y
		end
		if status_rotation then self.rotation = rotation end
		if status_sx or status_sy then
			self.sx = sx
			self.sy = sy
		end
		imgui.TreePop()
	end
end

return Transform
