local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local peachy = require("modules.peachy.peachy")

local Animation = System({
		C.anim,
		C.pos,
	})

function Animation:entityAdded(e)
	local c_anim = e[C.anim]
	local c_callback = e[C.anim_callback]
	c_anim.anim = peachy.new(c_anim.json, c_anim.sheet, c_anim.tag)
	c_anim.anim:onLoop(function()
		if c_anim.stopOnLast then
			c_anim.anim:stop(true)
		end
		if c_callback and c_callback.callback.onComplete then
			c_callback.callback.onComplete(c_anim.anim)
		end
		if c_callback and c_callback.volatile then
			e:remove(C.anim_callback):apply()
		end
	end)
	if e:has(C.transform) then self:getInstance():emit("handleAnim", e) end
end

function Animation:update(dt)
	for _,e in ipairs(self.pool) do
		local c_anim = e[C.anim]
		c_anim.anim:update(dt * (c_anim.speed or 1))
	end
end

function Animation:draw()
	for _,e in ipairs(self.pool) do
		local c_anim = e[C.anim]
		local c_color = e[C.color]
		local c_pos = e[C.pos].pos
		local c_transform = e[C.transform]
		if c_color then c_color.color:set() end
		if c_transform then
			c_anim.anim:draw(c_pos.x, c_pos.y, c_transform.rot, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy)
		else
			c_anim.anim:draw(c_pos.x, c_pos.y)
		end
	end
end

return Animation
