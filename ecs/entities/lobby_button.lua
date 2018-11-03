local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local LobbyButton = function(e, id, window)
	local img = window[C.sprite].sprite

	e:give(C.color, colors("white"))
		:give(C.button, id, {
				normal = resourceManager:getImage("button_" .. id),
				hovered = resourceManager:getImage("button_" .. id .. "_hovered")
			})
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.transform, 0, 2.5, 2.5, "center", "center")
		:give(C.maxScale, 2.75, 2.75)
		:give(C.windowIndex, 1)
		:apply()

	return e
end

return LobbyButton
