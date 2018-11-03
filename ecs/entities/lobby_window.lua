local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local LobbyWindow = function(e)
	e:give(C.color, colors("white"))
		:give(C.sprite, resourceManager:getImage("window"))
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.transform, 0, 2, 1.25, "center", "bottom")
		:apply()

	return e
end

return LobbyWindow
