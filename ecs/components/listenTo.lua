local Component = require("modules.concord.lib.component")

local ListenTo = Component(function(e, target)
	e.target = target
end)

return ListenTo
