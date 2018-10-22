local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")

local LobbyButtons = function(e, id, img)
		e:give(C.color, colors("white"))
		:give(C.button, id, {
				normal = resourceManager:getImage("button_" .. img),
				hovered = resourceManager:getImage("button_" .. img .. "_hovered"),
			})
		:give(C.pos, vec2())
		:give(C.transform, 0, 2.5, 2.5, "center", "center")
		:give(C.maxScale, 2.75, 2.75)
		:give(C.windowIndex, 1)
		:apply()

		return e
end

return LobbyButtons