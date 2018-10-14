local Entity = require("modules.concord.lib.entity")

local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")

local Scene = function(e, json, sheet, tag, stopOnLast, speed, sx, sy)
	e
	:give(C.color, colors("white"))
	:give(C.anim, json, sheet, {
			tag = tag or "default",
			stopOnLast = stopOnLast,
			speed = speed
		})
	:give(C.pos, vec2(0, 0))
	:give(C.transform, 0, sx or 1, sy or 1)
	:apply()

	return e
end

return Scene
