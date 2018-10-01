local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Spinner = System({
		C.spin,
		C.transform,
	})

local function normalizeAngle(angle)
    while angle > math.pi do angle = angle - 2*math.pi end
    while angle <= -math.pi do angle = angle + 2*math.pi end
    return angle
end

function Spinner:update(dt)
	local e
	for i = 1, self.pool.size do
		e = self.pool:get(i)
		local c_spin = e[C.spin].speed
		local c_transform = e[C.transform]
		c_transform.rot = normalizeAngle(c_transform.rot + math.rad(c_spin * dt))
	end
end

return Spinner
