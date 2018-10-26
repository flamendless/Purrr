local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local data = require("src.data")

local ButtonVolume = function(e, window)
	local img = resourceManager:getImage("button_volume")
	e:give(C.button, "Volume",
		{
			normal = resourceManager:getImage("button_volume"),
			hovered = resourceManager:getImage("button_volume_hovered"),
		})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.25, 2.25)
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.windowButton)
		:give(C.onClick, function()
				if data.data.volume == 1 then
					data.data.volume = 0
					gamestate:getCurrent().instance:emit("changeSprite", e,
						resourceManager:getImage("button_mute"),
						resourceManager:getImage("button_mute_hovered"))
				else
					data.data.volume = 1
					gamestate:getCurrent().instance:emit("changeSprite", e,
						resourceManager:getImage("button_volume"),
						resourceManager:getImage("button_volume_hovered"))
				end
				data:save()
			end)
		:apply()

	return e
end

return ButtonVolume
