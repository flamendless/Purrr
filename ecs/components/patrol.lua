local Component = require("modules.concord.lib.component")

local Patrol = Component(function(e, path, relevant)
	e.path = path
	e.isRelevant = (relevant == true) or false
	e.current = 1
end)

return Patrol
