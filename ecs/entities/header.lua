local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")

local Header = function(e, str)
	e:give(C.color, colors("white"))
		:give(C.pos, pos.customization.off_header:clone())
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.button, "header", {
				normal = resourceManager:getImage("header"),
				textColor = colors("flat", "white", "light"),
				text = str,
				font = resourceManager:getFont("header_42"),
			})
		:apply()

	return e
end

return Header
