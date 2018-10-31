local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.timer")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")
local screen = require("src.screen")

local Notice = function(e)
	e:give(C.color, colors("white"))
		:give(C.pos, pos.customization.off_notice:clone())
		:give(C.transform, 0, 4, 3.5, "center", "center")
		:give(C.text, "Accessories are currently unavailable!",
			resourceManager:getFont("upheaval_32"),
			"center",
			screen.x - pos.window.pad)
		:apply()

	return e
end

return Notice
