local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")

local ButtonCancel = function(e, window)
	local img = resourceManager:getImage("button_cancel")
	e:give(C.button, "Cancel",
		{
			normal = resourceManager:getImage("button_cancel"),
			hovered = resourceManager:getImage("button_cancel_hovered"),
		})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.25, 2.25)
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.windowButton)
		:give(C.offsetPos, vec2(-img:getWidth() * 2, 256))
		:give(C.onClick, function() gamestate:getCurrent().instance:emit("close") end)
		:apply()

	return e
end

return ButtonCancel
