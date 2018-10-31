local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")

local ButtonForward = function(e)
	e:give(C.color, colors("white"))
		:give(C.button, "forward", {
				normal = resourceManager:getImage("btn_forward"),
				hovered = resourceManager:getImage("btn_forward_hovered"),
			})
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, pos.customization.forward:clone())
		:give(C.maxScale, 2.5, 2.5)
		:apply()

	return e
end

return ButtonForward
