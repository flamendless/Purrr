local Component = require("modules.concord.lib.component")

local Animation = Component(function(e, obj)
	e.obj = obj
end)

return Animation
