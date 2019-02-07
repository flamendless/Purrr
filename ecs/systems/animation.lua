local System = require("modules.concord.lib.system")

local C = require("ecs.components")

local Animation = System({
		C.animation,
	})

function Animation:update(dt)
	for _, e in ipairs(self.pool) do
		local c_animation = e[C.animation].obj
		c_animation:update(dt)
	end
end

return Animation
