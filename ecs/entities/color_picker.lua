local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")

local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")

local ColorPicker = function(e, pal, id, btn_color, x, y)
	e:give(C.color, colors("white"))
		:give(C.button, id, {
				normal = resourceManager:getImage("btn_" .. btn_color),
				hovered = resourceManager:getImage("btn_" .. btn_color .. "_hovered"),
				text = id,
				font = resourceManager:getFont("buttons_24"),
				textColor = colors("white"),
				onClick = function(system)
					local instance = system:getInstance()
					instance:emit("changePalette", pal)

					local current = gamestate:getCurrent()
					current.entities.forward[C.state].isDisabled = false
				end
			})
		:give(C.transform, 0, 1, 1, "center", "center")
		:give(C.maxScale, 2.5, 2.5)
		:give(C.pos, vec2(x, y))
		:give(C.windowIndex, 1)
		:apply()

	return e
end

return ColorPicker
