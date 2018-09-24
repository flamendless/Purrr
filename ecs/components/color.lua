local Component = require("modules.concord.lib.component")

local Color = Component(function(e, color, a)
	e.color = color
	e.color[4] = a or e.color[4]
end)

return Color
