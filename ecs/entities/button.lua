local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local screen = require("src.screen")

local Button = function(e, id, pos, args)
	e:give(C.color, colors("white"))
	:give(C.button, id, args)
	:give(C.maxScale, 1.25, 1.25)
	:give(C.transform, 0, 1, 1, "center", "center")
	:give(C.pos, pos)
	:apply()

	return e
end

return Button
