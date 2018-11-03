local C = require("ecs.components")
local data = require("src.data")
local resourceManager = require("src.resource_manager")
local event = require("src.event")
local pos = require("src.positions")
local colors = require("src.colors")

local ButtonEnergy = function(e, window)
	local energy = "energy_" .. data.data.energy
	local spr = resourceManager:getImage(energy)
	e:give(C.color, colors("white"))
	:give(C.button, "energy", {
			normal = spr,
			hovered = spr,
		})
	:give(C.pos, pos.screen.top:clone())
	:give(C.transform, 0, 1.5, 1.5)
	:give(C.maxScale, 1.75, 1.75)
	:give(C.windowIndex, 1)
	:give(C.onClick, function(e) event:showEnergyInfo() end)
	:apply()

	return e
end

return ButtonEnergy
