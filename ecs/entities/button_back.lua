local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local screen = require("src.screen")

local ButtonBack = function(e, window)
	local img = resourceManager:getImage("button_back")
	e:give(C.button, "Back",
		{
			normal = resourceManager:getImage("button_back"),
			hovered = resourceManager:getImage("button_back_hovered"),
		})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.25, 2.25)
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.windowButton)
		:give(C.offsetPos, vec2(0, screen.y * 0.25))
		:give(C.onClick, function() gamestate:getCurrent().instance:emit("close") end)
		:apply()

	return e
end

return ButtonBack
