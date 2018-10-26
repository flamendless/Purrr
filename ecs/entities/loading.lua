local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

local Loading = function(e)
	local img = love.graphics.newImage("assets/anim/preload.png")
	local color = colors("random-flat")
	resourceManager:add("images", "cat", img)
	img:setFilter("nearest", "nearest")

	e:give(C.color, color)
		:give(C.anim, "assets/anim/json/preload.json", img)
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 2, 2, "center", "center")
		:apply()

	return e
end

return Loading
