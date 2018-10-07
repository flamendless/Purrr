local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local Position = System({
		C.pos,
		C.parent,
	})

function Position:entityAddedTo(e, pool)
end

function Position:update(dt)
	for _,e in ipairs(self.pool) do
		local parent = e[C.parent].parent
		local p_pos = parent[C.pos]
		if p_pos then
			p_pos = parent[C.pos].pos
			local c_pos = e[C.pos].pos
			c_pos.x = p_pos.x
			c_pos.y = p_pos.y
		end
	end
end

return Position
