local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")

local ButtonHome = function(e)
		e:give(C.button, "Home",
			{
				normal = resourceManager:getImage("button_home"),
				hovered = resourceManager:getImage("button_home_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 1.5, 1.5, "right")
		:give(C.pos, pos.screen.top:clone())
		:give(C.maxScale, 1.75, 1.75)
		:give(C.windowIndex, 1)
		:give(C.onClick, function() event:showTitleConfirmation() end)
		:apply()

	return e
end

return ButtonHome
