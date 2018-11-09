local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local event = require("src.event")
local gamestate = require("src.gamestate")

local ButtonErase = function(e, window)
	e:give(C.button, "Erase",
		{
			normal = resourceManager:getImage("button_erase"),
			hovered = resourceManager:getImage("button_erase_hovered"),
		})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, vec2())
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowButton)
		:give(C.follow, window)
		:give(C.offsetPos, pos.window.erase:clone())
		:give(C.onClick, function() event:showEraseConfirmation() end)
		:give(C.onHover, function(e) gamestate:getCurrent().instance:emit("changeWindowTitle", "Erase Data") end)
		:give(C.onExit, function(e) gamestate:getCurrent().instance:emit("changeWindowTitle", "SETTINGS") end)
		:apply()

	return e
end

return ButtonErase
