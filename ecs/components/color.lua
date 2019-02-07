local Component = require("modules.concord.lib.component")

local Color = Component(function(e, color)
	e.color = color or {1, 1, 1, 1}
end)

return Color
