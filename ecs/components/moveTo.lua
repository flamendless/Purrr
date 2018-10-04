local Component = require("modules.concord.lib.component")

local MoveTo = Component(function(e, target, dir)
	e.target = target
	e.dir = dir
end)

return MoveTo
