local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")

local SquareTransform = System({
		C.square,
		C.cornerRadius,
		C.pos,
		C.colors,
		C.shapeTransform,
	})

local dur = 1.75

function SquareTransform:entityAdded(e)
	local c_cornerRadius = e[C.cornerRadius].size
	local c_shapeTransform = e[C.shapeTransform]
	local c_square = e[C.square].size
	dur = c_shapeTransform.dur
	if c_cornerRadius >= c_square.x/2 then
		self:toRect(e)
	elseif c_cornerRadius <= 0 then
		self:toCircle(e)
	end
end

function SquareTransform:toRect(e)
	local c_square = e[C.square]
	local c_cornerRadius = e[C.cornerRadius]
	local c_colors = e[C.colors].colors
	local c_color = e[C.color]
	flux.to(c_cornerRadius, dur, { size = 0 })
		:onstart(function()
			self:getInstance():emit("change", e, dur)
		end)
		:oncomplete(function()
			self:toCircle(e)
		end)
end

function SquareTransform:toCircle(e)
	local c_square = e[C.square]
	local c_cornerRadius = e[C.cornerRadius]
	local c_colors = e[C.colors].colors
	local c_color = e[C.color]
	flux.to(c_cornerRadius, dur, { size = c_square.size.x/2 })
		:onstart(function()
			self:getInstance():emit("change", e, dur)
		end)
		:oncomplete(function()
			self:toRect(e)
		end)
end

function SquareTransform:transformToNone(e)
	local c_square = e[C.square]
	local c_cornerRadius = e[C.cornerRadius]
	local c_pos = e[C.pos]
	flux.to(c_cornerRadius, dur, { size = 0 })
	flux.to(c_square.size, dur, { x = 0, y = 0 })
		:onupdate(function()
			c_pos.pos.x = c_pos.orig_pos.x - c_square.size.x/2
			c_pos.pos.y = c_pos.orig_pos.y - c_square.size.y/2
		end)
end

return SquareTransform
