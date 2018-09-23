local Component = require("modules.concord.lib.component")

local Color = Component(function(e, color)
	e.color = color
end)

return Color
