local Component = require("modules.concord.lib.component")

local Position = Component(function(e, pos)
	e.pos = pos
end)

return Position
