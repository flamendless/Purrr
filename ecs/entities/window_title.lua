local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local screen = require("src.screen")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local WindowTitle = function(e, window, text)
	e:give(C.color, colors("white"))
		:give(C.text,
			text,
			resourceManager:getFont("title_48"),
			"center",
			screen.x - pos.window.title_pad)
		:give(C.pos, vec2())
		:give(C.parent, window)
		:give(C.offsetPos, pos.window.title:clone())
		:apply()

	return e
end

return WindowTitle
