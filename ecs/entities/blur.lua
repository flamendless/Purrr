local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")

local Blur = function(e, window)
	local img = resourceManager:getImage("bg_space")
	e:give(C.color, { 1, 1, 1, 0.9 })
		:give(C.sprite, img)
		:give(C.pos, vec2())
		:give(C.transform, 0, screen.x/img:getWidth(), screen.y/img:getHeight() * 2, "center", "center")
		:give(C.follow, window)
		:apply()

	return e
end

return Blur
