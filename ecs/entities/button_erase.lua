local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local data = require("src.data")

local ButtonErase = function(e, window)
		e:give(C.button, "Erase",
			{
				normal = resourceManager:getImage("button_erase"),
				hovered = resourceManager:getImage("button_erase_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, vec2())
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowButton)
		:give(C.follow, window)
		:give(C.offsetPos, pos.window.erase:clone())
		:give(C.onClick, function() data:erase() end)
		:apply()

	return e
end

return ButtonErase
