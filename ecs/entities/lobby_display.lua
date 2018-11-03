local C = require("ecs.components")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local pos = require("src.positions")

local LobbyDisplay = function(e)
	e:give(C.color, colors("white"))
		:give(C.pos, pos.screen.bottom:clone())
		:give(C.sprite, resourceManager:getImage("display_lobby"))
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	return e
end

return LobbyDisplay
