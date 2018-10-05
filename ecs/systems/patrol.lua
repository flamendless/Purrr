local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local Patrol = System({
		C.patrol,
		C.speed,
		C.pos,
	})

function Patrol:entityAdded(e)
	local c_pos = e[C.pos].pos
	local c_patrol = e[C.patrol]
	c_patrol.backup_pos = c_pos:clone()
	if c_patrol.isRelevant then
		for i = 1, #c_patrol.path do
			local p = c_patrol.path[i]
			p.x = p.x + c_pos.x
			p.y = p.y + c_pos.y
		end
	end
	self:startPatrol(e)
end

function Patrol:entityRemoved(e)
	local c_pos = e[C.pos]
	local c_patrol = e[C.patrol]
	c_pos.pos = c_patrol.backup_pos:clone()
end

function Patrol:startPatrol(e)
	local c_speed = e[C.speed].speed
	local c_pos = e[C.pos].pos
	local c_patrol = e[C.patrol]

	local current = c_patrol.path[c_patrol.current]
	local dir = vec2(0, 0)
	if current.x < c_pos.x then dir.x = -1
	else dir.x = 1
	end
	if current.y < c_pos.y then dir.y = -1
	else dir.y = 1
	end
	e:give(C.moveTo, current, dir):apply()

	if c_patrol.current < #c_patrol.path then
		c_patrol.current = c_patrol.current + 1
	else
		c_patrol.current = 1
	end
end

return Patrol
