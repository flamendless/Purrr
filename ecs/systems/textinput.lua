local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local timer = require("modules.hump.timer")
local gamestate = require("src.gamestate")
local utf8 = require("utf8")

local TextInput = System({
		C.textinput,
		C.text,
	})

local maxLength = 9
local sec = 1
local amount = 1
local dir = -1
local erased = false

function TextInput:init()
	_erased = false
	self.timer = timer()
	self.text_timer = timer()
end

function TextInput:entityAdded(e)
	local c_color = e[C.color]
	local c_textinput = e[C.textinput]
	c_textinput.buffer = e[C.text].text
	self.timer:every(sec, function()
		dir = dir * -1
	end)
	love.keyboard.setKeyRepeat(true)
end

function TextInput:update(dt)
	if self.timer then self.timer:update(dt) end
	for _,e in ipairs(self.pool) do
		local c_color = e[C.color]
		local c_textinput = e[C.textinput]
		local c_text = e[C.text]
		c_color.color[4] = c_color.color[4] + (amount * dir) * dt
		c_text.text = c_textinput.buffer
	end
end

function TextInput:keypressed(key)
	if key == "backspace" then
		for _,e in ipairs(self.pool) do
			local c_textinput = e[C.textinput]
    	local byteoffset = utf8.offset(c_textinput.buffer, -1)
    	if byteoffset then
      	c_textinput.buffer = string.sub(c_textinput.buffer, 1, byteoffset - 1)
    	end
		end
	end
end

function TextInput:textinput(t)
	for _,e in ipairs(self.pool) do
		local c_textinput = e[C.textinput]
		if not erased then
			c_textinput.buffer = ""
			erased = true
		end
		c_textinput.buffer = c_textinput.buffer .. t
	end
end

return TextInput
