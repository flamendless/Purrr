local Component = require("modules.concord.lib.component")

local Points = Component(function(e, current, ...)
	e.points = {...}
	e.index = current or 1
	e.current = e.points[e.index]
end)

return Points
