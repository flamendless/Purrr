local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local vec2 = require("modules.hump.vector")

local TitleBG = function(e)
	local image = resourceManager:getImage("bg")
	local sx = screen.x/image:getWidth()
	local sy = screen.y/image:getHeight()
	e:give(C.bg, image)
		:give(C.color, colors("white"))
		:give(C.pos, vec2())
		:give(C.transform, 0, sx, sy)
		:apply()

	return e
end

return TitleBG
