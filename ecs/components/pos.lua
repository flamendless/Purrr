local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local Position = Component(function(e, pos)
	e.pos = pos
	e.orig_pos = vec2(pos.x, pos.y)
end)

return Position
