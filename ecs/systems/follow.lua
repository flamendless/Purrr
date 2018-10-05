local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Follow = System({
		C.pos,
		C.follow,
	})

function Follow:entityAdded(e)
end

function Follow:update(dt)
	for _,e in ipairs(self.pool) do
		local c_pos = e[C.pos].pos
		local c_target = e[C.follow].target[C.pos].pos
		local c_speed = e[C.speed]
		if c_speed then
		else
			c_pos.x = c_target.x
			c_pos.y = c_target.y
		end
		self:getInstance():emit("updatePosition")
	end
end

return Follow
