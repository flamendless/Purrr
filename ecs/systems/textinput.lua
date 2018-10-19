local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local timer = require("modules.hump.timer")

local TextInput = System({
		C.textinput,
		C.text,
	})

local sec = 1
local amount = 1
local dir = -1

function TextInput:init()
	self.timer = timer()
end

function TextInput:entityAdded(e)
	local c_color = e[C.color]
	self.timer:every(sec, function()
		dir = dir * -1
	end)
end

function TextInput:update(dt)
	for _,e in ipairs(self.pool) do
		local c_color = e[C.color]
		c_color.color[4] = c_color.color[4] + (amount * dir) * dt
	end
	if self.timer then self.timer:update(dt) end
end

return TextInput
