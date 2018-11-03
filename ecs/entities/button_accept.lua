local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local ButtonAccept = function(e, window, state)
	local img = resourceManager:getImage("button_accept")
	e:give(C.button, "Accept",
		{
			normal = resourceManager:getImage("button_accept"),
			hovered = resourceManager:getImage("button_accept_hovered"),
			disabled = state,
		})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.25, 2.25)
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.windowButton)
		:give(C.offsetPos, vec2(img:getWidth()* 2, 256))
		:apply()

	return e
end

return ButtonAccept
