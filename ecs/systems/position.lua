local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local Position = System({
		C.parent,
	})

function Position:entityAddedTo(e, pool)
	local parent = e[C.parent].parent
	local p_pos = parent[C.pos].pos
	local p_transform = parent[C.transform]
	local c_pos = e[C.pos].pos
	local c_transform = e[C.transform]

	c_pos.x = p_pos.x
	c_pos.y = p_pos.y

	if c_transform then
		c_transform.rot = p_transform.rot
		c_transform.sx = p_transform.sx
		c_transform.sy = p_transform.sy
		c_transform.ox = p_transform.ox
		c_transform.oy = p_transform.oy
	end
end

return Position
