local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")

local TextInput = function(e, window, str_default)
	local font = resourceManager:getFont("body_36")
	local img = window[C.sprite].sprite
	e:give(C.color, colors("white"))
		:give(C.textinput)
		:give(C.text, str_default, font, "center", screen.x - pos.window.body_pad)
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.25, 2.25)
		:give(C.pos, vec2())
		:give(C.follow, window)
		:give(C.windowButton)
		:give(C.offsetPos, vec2(-img:getWidth()/2 - pos.window.body_pad/2))
		:apply()

	return e
end

return TextInput
