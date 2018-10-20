local Component = require("modules.concord.lib.component")

local Circle = Component(function(e, mode, radius, segments)
	e.mode = mode
	e.radius = radius
	e.segments = segments or radius
end)

return Circle
