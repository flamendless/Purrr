local Component = require("modules.concord.lib.component")

local TargetPos = Component(function(e, pos)
	e.pos = pos
end)

return TargetPos
