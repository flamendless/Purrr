local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local ColliderRect = Component(function(e, pos, size)
	assert(vec2.isvector(pos), "pos must be a vector")
	assert(vec2.isvector(size), "size must be a vector")
	e.pos = pos
	e.size = size
end)

return ColliderRect
