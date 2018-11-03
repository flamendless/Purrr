local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local screen = require("src.screen")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local WindowBody = function(e, window, text)
	e:give(C.color, colors("white"))
		:give(C.text,
			text,
			resourceManager:getFont("body_36"),
			"center",
			screen.x - pos.window.body_pad)
		:give(C.pos, vec2())
		:give(C.parent, window)
		:give(C.offsetPos, pos.window.body:clone())
		:apply()

	return e
end

return WindowBody
