local Component = require("modules.concord.lib.component")

local OnUpdate = Component(function(e, func)
	e.onUpdate = func
end)

return OnUpdate
