local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")

local Cat = function(e)
	e:give(C.tag, "cat")
		:give(C.cat)
		:give(C.fsm, "blink", { "blink", "hurt", "heart", "mouth", "sleep", "snore", "spin"})
		:give(C.color, colors("white"))
		:give(C.pos, pos.customization.off_cat:clone())
		:give(C.transform, 0, 4, 4, "center", "center")
		:apply()

	return e
end

return Cat
