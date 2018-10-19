local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local timer = require("modules.hump.timer")
local gamestate = require("src.gamestate")
local utf8 = require("utf8")

local TextInput = System({
		C.textinput,
		C.text,
	})

local _erased
local text
local maxLength = 12
local sec = 1
local amount = 1
local dir = -1

function TextInput:init()
	_erased = false
	self.timer = timer()
	self.text_timer = timer()
end

function TextInput:entityAdded(e)
	local c_color = e[C.color]
	text = e[C.text].text
	self.timer:every(sec, function()
		dir = dir * -1
	end)
	self.timer:every(0.15, function()
		self:updateText()
	end)
	love.keyboard.setKeyRepeat(true)
end

function TextInput:update(dt)
	if self.timer then self.timer:update(dt) end
	if self.text_timer then self.text_timer:update(dt) end
	for _,e in ipairs(self.pool) do
		local c_color = e[C.color]
		c_color.color[4] = c_color.color[4] + (amount * dir) * dt
	end
	if #text <= 0 then
		gamestate:send("disableAcceptButton")
	elseif #text >= 3 then
		gamestate:send("enableAcceptButton")
	end
end

function TextInput:updateText()
	for _,e in ipairs(self.pool) do
		local c_text = e[C.text]
		c_text.text = text
	end
end

function TextInput:keypressed(key)
	if key == "backspace" then
    local byteoffset = utf8.offset(text, -1)
    if byteoffset then
      text = string.sub(text, 1, byteoffset - 1)
    end
	end
end

function TextInput:textinput(t)
	if not _erased then
		text = ""
		_erased = true
	end
	if #text <= maxLength then
		text = text .. t
	end
end

return TextInput
