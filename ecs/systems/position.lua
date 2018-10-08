local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local Position = System({
		C.pos,
		C.parent,
	}, {
		C.window,
		C.pos,
		C.parent,
		C.text,
		"gui"
	})

function Position:entityAddedTo(e, pool)
	if pool.name == "pool" then
		local parent = e[C.parent].parent
		local p_pos = parent[C.pos]
		if p_pos then
			p_pos = parent[C.pos].pos
			local c_pos = e[C.pos].pos
			c_pos.x = p_pos.x
			c_pos.y = p_pos.y
		end
		if e[C.parent].once then
			e:remove(C.parent):apply()
		end
	end
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

	for _,e in ipairs(self.gui) do
		local parent = e[C.parent].parent
		local p_pos = parent[C.pos].pos
		local p_sprite = parent[C.sprite].sprite
		local p_transform = parent[C.transform]

		local c_pos = e[C.pos].pos
		local c_text = e[C.text]
		local x, y

		x = p_pos.x - p_sprite:getWidth()/2 * p_transform.sx
		y = p_pos.y - p_sprite:getHeight()/2 * p_transform.sy

		c_pos.x = x
		c_pos.y = y
	end
end

return Position
