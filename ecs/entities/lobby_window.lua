local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")

local LobbyWindow = function(e)
	e:give(C.color, colors("white"))
		:give(C.sprite, resourceManager:getImage("window"))
		:give(C.pos, pos.lobby.off_window:clone())
		:give(C.transform, 0, 2, 1.25, "center", "bottom")
		:apply()

	return e
end

return LobbyWindow
