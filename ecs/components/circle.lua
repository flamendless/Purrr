local Component = require("modules.concord.lib.component")

local Circle = Component(function(e, mode, radius, segments)
	e.mode = mode
	e.radius = radius
	e.segments = segments or radius
	e.points = nil
end)

return Circle
