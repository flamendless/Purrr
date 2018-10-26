local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local ButtonErase = function(e)
		e:give(C.button, "Erase",
			{
				normal = resourceManager:getImage("button_erase"),
				hovered = resourceManager:getImage("button_erase_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "left", "bottom")
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowIndex, 1)
		:apply()

	return e
end

return ButtonErase
