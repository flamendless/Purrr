local Component = require("modules.concord.lib.component")

local Float = Component(function(e, floatPos)
	e.floatPos = floatPos
end)

return Float
