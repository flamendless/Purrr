local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")

local ButtonSettings = function(e)
		e:give(C.button, "Settings",
			{
				normal = resourceManager:getImage("button_settings"),
				hovered = resourceManager:getImage("button_settings_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 1.5, 1.5, "right", "bottom")
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowIndex, 1)
		:give(C.onClick, function() event:showSettings() end)
		:apply()

	return e
end

return ButtonSettings
