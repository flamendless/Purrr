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

local dur = {
	[1] = 0.75,
	[2] = 1.5,
	[3] = 1.5,
}
local current = 1
local isCircle = true

function SquareTransform:entityAdded(e)
	local c_cornerRadius = e[C.cornerRadius].size
	local c_square = e[C.square].size
	self:start(e)
end

function SquareTransform:start(e)
	local c_cornerRadius = e[C.cornerRadius]
	local c_square = e[C.square]
	local c_pos = e[C.pos]
	if current == 1 then --to none
		flux.to(c_square.size, dur[current], { x = c_square.orig_size.x/4, y = c_square.orig_size.y/4 })
			:ease("backin")
			:onstart(function() self:getInstance():emit("change", e, dur[current]) end)
			:onupdate(function() self:updateTransform(e) end)
			:oncomplete(function()
				if isCircle then
					current = 2
				else
					current = 3
				end
				self:start(e)
			end)

	elseif current == 2 then --to rect
		flux.to(c_cornerRadius, dur[current], { size = 0 })
		flux.to(c_square.size, dur[current], { x = c_square.orig_size.x, y = c_square.orig_size.y })
			:onstart(function() self:getInstance():emit("change", e, dur[current]) end)
			:onupdate(function() self:updateTransform(e) end)
			:oncomplete(function()
				isCircle = false
				current = 1
				self:start(e)
			end)

	elseif current == 3 then --to circle
		flux.to(c_square.size, dur[current], { x = c_square.orig_size.x, y = c_square.orig_size.y })
		flux.to(c_cornerRadius, dur[current], { size = c_cornerRadius.orig_size })
			:onstart(function() self:getInstance():emit("change", e, dur[current]) end)
			:onupdate(function() self:updateTransform(e) end)
			:oncomplete(function()
				isCircle = true
				current = 1
				self:start(e)
			end)
	end
end

function SquareTransform:updateTransform(e)
	local c_square = e[C.square]
	local c_cornerRadius = e[C.cornerRadius]
	local c_pos = e[C.pos]
	c_pos.pos.x = c_pos.orig_pos.x - c_square.size.x/2
	c_pos.pos.y = c_pos.orig_pos.y - c_square.size.y/2
end

return SquareTransform
