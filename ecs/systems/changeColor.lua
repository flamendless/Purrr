local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")

local ChangeColor = System({
		C.colors,
		C.changeColor,
	})

local current = 1
local maxCurrent = 0
local backup = {}

function ChangeColor:entityAdded(e)
	maxCurrent = #e[C.colors].colors
	e:give(C.color, e[C.colors].colors[current]):apply()
end

function ChangeColor:change(e, dur)
	local c_color = e[C.color]
	local c_colors = e[C.colors].colors
	backup = {c_color.color[1], c_color.color[2], c_color.color[3]}
	flux.to(c_color.color, dur, {
			[1] = c_colors[current+1][1],
			[2] = c_colors[current+1][2],
			[3] = c_colors[current+1][3],
		})
		:oncomplete(function()
			c_colors[current+1][1] = backup[1]
			c_colors[current+1][2] = backup[2]
			c_colors[current+1][3] = backup[3]
			if current < maxCurrent then
				current = current + 1
			else
				current = 1
			end
		end)
end

return ChangeColor
