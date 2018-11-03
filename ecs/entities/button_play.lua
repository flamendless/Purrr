local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local transition = require("src.transition")

local ButtonPlay = function(e, next_state)
		e:give(C.button, "Play",
			{
				normal = resourceManager:getImage("btn_play"),
				hovered = resourceManager:getImage("btn_play_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 3, 3, "center", "center")
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowIndex, 1)
		:give(C.onClick, function() transition:start(next_state) end)
		:apply()

	return e
end

return ButtonPlay
