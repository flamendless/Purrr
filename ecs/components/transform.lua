local Component = require("modules.concord.lib.component")

local Transform = Component(function(e, rot, sx, sy, ox, oy)
	e.rot = rot or 0
	e.sx = sx or 1
	e.sy = sy or 1
	e.ox = ox or 0
	e.oy = oy or 0
end)

return Transform
