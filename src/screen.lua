local vec2 = require("modules.hump.vector")

local Screen = {
	size = vec2(love.graphics.getWidth(), love.graphics.getHeight()),
	pad = 32,
}

local mt = { __index = Screen.size }
setmetatable(Screen, mt)

return Screen
