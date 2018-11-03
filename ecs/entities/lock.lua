local C = require("ecs.components")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")

local Lock = function(e)
	e:give(C.color, colors("white", 0.5))
		:give(C.pos, pos.customization.off_lock:clone())
		:give(C.sprite, resourceManager:getImage("lock"))
		:give(C.transform, 0, 4, 3.5, "center", "center")
		:apply()

	return e
end

return Lock
