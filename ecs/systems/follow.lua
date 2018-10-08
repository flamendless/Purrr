local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Follow = System({
		C.pos,
		C.follow,
	})

function Follow:update(dt)
	for _,e in ipairs(self.pool) do
		local c_pos = e[C.pos].pos
		local c_target = e[C.follow].target[C.pos].pos
		local c_offset = e[C.offsetPos]
		if c_offset then
			c_pos.x = c_target.x + c_offset.offset.x
			c_pos.y = c_target.y + c_offset.offset.y
		else
			c_pos.x = c_target.x
			c_pos.y = c_target.y
		end
	end
end

return Follow
