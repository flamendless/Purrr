local Component = require("modules.concord.lib.component")

local vec2 = require("modules.hump.vector")

local Transform = Component(function(e, pos, rotation, sx, sy, ox, oy, kx, ky)
	assert(vec2.isvector(pos), "pos must be a vector object")
	e.pos = pos
	e.rotation = rotation or 0
	e.sx = sx or 1
	e.sy = sy or 1
	e.ox = ox or 0
	e.oy = oy or 0
	e.kx = kx or 0
	e.ky = ky or 0
end)

return Transform
