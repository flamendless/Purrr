local vec2 = require("modules.hump.vector")
local log = require("modules.log.log")

local Screen = {
	-- size = vec2(love.graphics.getWidth(), love.graphics.getHeight()),
	size = vec2(480, 800),
}

local mt = { __index = Screen.size }
setmetatable(Screen, mt)

return Screen
