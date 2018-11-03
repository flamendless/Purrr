local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local pos = require("src.positions")
local resourceManager = require("src.resource_manager")
local data = require("src.data")

local ButtonTwitter = function(e, window)
	local img = resourceManager:getImage("button_twitter")
	e:give(C.button, "Twitter",
		{
			normal = resourceManager:getImage("button_twitter"),
			hovered = resourceManager:getImage("button_twitter_hovered"),
		})
		:give(C.color, colors("white"))
		:give(C.pos, vec2())
		:give(C.maxScale, 2.25, 2.25)
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.windowButton)
		:give(C.follow, window)
		:give(C.offsetPos, pos.window.twitter:clone())
		:give(C.onClick, function() love.system.openURL(data.dev.twitter) end)
		:apply()

	return e
end

return ButtonTwitter
