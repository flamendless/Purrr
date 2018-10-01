local Component = require("modules.concord.lib.component")

local FillMode = Component(function(e, mode)
	e.mode = mode
end)

return FillMode
