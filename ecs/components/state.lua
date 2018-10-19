local Component = require("modules.concord.lib.component")

local State = Component(function(e)
	e.isDisabled = false
	e.isClicked = false
	e.isHovered = false
end)

return State
