local Component = require("modules.concord.lib.component")

local OnExit = Component(function(e, func)
	e.onExit = func
end)

return OnExit
