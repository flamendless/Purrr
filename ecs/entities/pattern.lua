local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local lume = require("modules.lume.lume")
local vec2 = require("modules.hump.vector")

local Pattern = function(e)
	local img = {}
	for i = 1, 9 do img[i] = resourceManager:getImage("pattern" .. i) end
	local pattern = lume.randomchoice(img)
	local sx = screen.x/pattern:getWidth()
	local sy = screen.y/pattern:getHeight()
	e:give(C.bg, pattern)
		:give(C.color, colors("white"))
		:give(C.pos, vec2())
		:give(C.transform, 0, sx, sy)
		:apply()

	return e
end

return Pattern
