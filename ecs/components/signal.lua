local Component = require("modules.concord.lib.component")

local Signal = Component(function(e, id)
	e.id = id
end)

return Signal
