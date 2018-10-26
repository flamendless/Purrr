local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local Title = function(e)
	e:give(C.color, colors("white"))
		:give(C.sprite, resourceManager:getImage("title"))
		:give(C.pos, pos.screen.top)
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	return e
end

return Title
