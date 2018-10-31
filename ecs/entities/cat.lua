local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")

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
