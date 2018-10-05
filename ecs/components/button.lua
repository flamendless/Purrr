local Component = require("modules.concord.lib.component")

local Button = Component(function(e, id, args)
	e.id = id
	e.args = args
	e.isHovered = false
	e.isClicked = false
end)

return Button
