local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local MoveTo = System({
		C.pos,
		C.moveTo,
		C.speed,
	})

function MoveTo:update(dt)
	for _,e in ipairs(self.pool) do
		local c_pos = e[C.pos].pos
		local c_target = e[C.moveTo].target
		local c_speed = e[C.speed].speed
		local dir = e[C.moveTo].dir
		c_pos.x = c_pos.x + c_speed.x * dir.x * dt
		c_pos.y = c_pos.y + c_speed.y * dir.y * dt
		local hit = 0

		if dir.x == 1 then
			if c_pos.x <= c_target.x then
				hit = hit + 1
			end
		else
			if c_pos.x >= c_target.x then
				hit = hit + 1
			end
		end
		if dir.y == 1 then
			if c_pos.y >= c_target.y then
				hit = hit + 1
			end
		else
			if c_pos.y <= c_target.y then
				hit = hit + 1
			end
		end
		if hit == 2 then
			e:remove(C.moveTo):apply()
			self:getInstance():emit("startPatrol", e)
		end
	end
end

return MoveTo
