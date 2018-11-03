local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")

local Window = function(e, spr, sx, sy)
	e:give(C.window)
		:give(C.sprite, spr)
		:give(C.color, colors(1, 1, 1, 1))
		:give(C.pos, pos.screen.top:clone())
		:give(C.transform, 0, sx, sy, "center", "center")
		:apply()

	return e
end

return Window
