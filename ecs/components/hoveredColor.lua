local Component = require("modules.concord.lib.component")

local HoveredColor = Component(function(e, color, state)
	e.color = color
	e.state = false
end)

return HoveredColor
