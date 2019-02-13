local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local ColliderRect = Component(function(e, size)
	assert(vec2.isvector(size), "size must be a vector")
	e.size = size
end)

return ColliderRect
