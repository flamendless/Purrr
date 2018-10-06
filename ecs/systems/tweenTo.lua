local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")

local TweenTo = System({
		C.pos,
		C.tween,
		C.targetPos,
	})

function TweenTo:entityAdded(e)
	local c_pos = e[C.pos].pos
	local c_tween = e[C.tween]
	local c_target = e[C.targetPos].pos
	flux.to(c_pos, c_tween.dur, {
			x = c_target.x,
			y = c_target.y
		})
		:delay(c_tween.delay)
		:ease(c_tween.ease)
		:oncomplete(function()
			local c_onComplete = e[C.tween_onComplete]
			if c_onComplete then
				c_onComplete.fn()
				e:remove(C.tween_onComplete):apply()
			end
			e:remove(C.tween)
				:remove(C.targetPos)
				:apply()
		end)
end

return TweenTo
