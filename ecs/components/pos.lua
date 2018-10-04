local Component = require("modules.concord.lib.component")

local Position = Component(function(e, pos)
	e.pos = pos
	e.orig_pos = e.pos:clone()
end)

return Position
