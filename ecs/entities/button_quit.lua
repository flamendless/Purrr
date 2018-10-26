local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.timer")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")

local ButtonQuit = function(e, play)
		e:give(C.button, "Quit",
			{
				normal = resourceManager:getImage("btn_leave"),
				hovered = resourceManager:getImage("btn_leave_hovered"),
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 1.5, 1.5, "center", "center")
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.maxScale, 1.25, 1.25)
		:give(C.windowIndex, 1)
		:give(C.follow, play)
		:give(C.onClick, function() event:showExitConfirmation() end)
		:apply()

	return e
end

return ButtonQuit
