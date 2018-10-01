local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Spinner = System({
		C.spin,
		C.transform,
	})

function Spinner:update(dt)
	local e
	for i = 1, self.pool.size do
		e = self.pool:get(i)
		local c_spin = e[C.spin].speed
		local c_transform = e[C.transform]
		c_transform.rot = c_transform.rot + c_spin * dt
	end
end

return Spinner
