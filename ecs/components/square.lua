local Component = require("modules.concord.lib.component")

local Square = Component(function(e, mode, size)
	e.mode = mode
	e.size = size
end)

return Square
