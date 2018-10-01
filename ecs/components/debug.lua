local Component = require("modules.concord.lib.component")

local Debug = Component(function(e, state)
	e.state = state
end)

return Debug
