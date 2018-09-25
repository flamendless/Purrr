local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Transform = System({
		C.transform,
		C.sprite,
		"sprite"
	}, {
		C.square,
		C.transform,
		C.pos,
		"square"
	})

function Transform:entityAddedTo(e, pool)
	if pool.name == "sprite" then
		local c_sprite = e[C.sprite].sprite
		local c_transform = e[C.transform]
		if c_transform.ox == "center" then
			c_transform.ox = c_sprite:getWidth()/2
		elseif c_transform.ox == "right" then
			c_transform.ox = c_sprite:getWidth()
		end
		if c_transform.oy == "center" then
			c_transform.oy = c_sprite:getHeight()/2
		elseif c_transform.oy == "bottom" then
			c_transform.oy = c_sprite:getHeight()
		end
	elseif pool.name == "square" then
		local c_square = e[C.square].size
		local c_pos = e[C.pos].pos
		local c_transform = e[C.transform]
		if c_transform.ox == "center" then
			c_pos.x = c_pos.x - c_square.x/2
		end
		if c_transform.oy == "center" then
			c_pos.y = c_pos.y - c_square.y/2
		end
	end
end

return Transform
