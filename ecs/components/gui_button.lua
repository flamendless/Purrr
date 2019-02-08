local Component = require("modules.concord.lib.component")

local GUIButton = Component(function(e, isActive)
	e.state = {
		isActive = (isActive == false) or true,
		isEntered = false,
		isClicked = false,
	}
end)

return GUIButton
