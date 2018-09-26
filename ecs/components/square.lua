local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local Square = Component(function(e, mode, size)
	e.mode = mode
	e.size = size
	e.orig_size = vec2(size.x, size.y)
end)

return Square
