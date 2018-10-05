local Component = require("modules.concord.lib.component")

local Button = Component(function(e, id, text)
	e.id = id
	e.text = text
	e.isHovered = false
	e.isClicked = false
end)

return Button
