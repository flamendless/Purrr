local C = require("ecs.components")
local resourceManager = require("src.resource_manager")
local colors = require("src.colors")
local pos = require("src.positions")
local event = require("src.event")

local ButtonCatInfo = function(e)
	local spr = resourceManager:getImage("button_cat_info")
	local spr_hovered = resourceManager:getImage("button_cat_info_hovered")
	e:give(C.color, colors("white"))
		:give(C.transform, 0, 1.5, 1.5)
		:give(C.maxScale, 1.75, 1.75)
		:give(C.pos, pos.screen.top:clone())
		:give(C.button, "cat_info", {
				normal = spr,
				hovered = spr_hovered,
			})
		:give(C.onClick, function(e) event:showCatInfo() end)
		:apply()

	return e
end

return ButtonCatInfo
