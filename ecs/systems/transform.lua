local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Transform = System({
		C.transform,
		C.sprite,
		"sprite"
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
	end
end

return Transform
