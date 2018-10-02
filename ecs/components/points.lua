local Component = require("modules.concord.lib.component")

local Points = Component(function(e, points)
	e.points = points
end)

return Points
