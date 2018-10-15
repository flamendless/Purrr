local Component = require("modules.concord.lib.component")

local Shaders = Component(function(e, shaders, ...)
	e.shaders = shaders
	e.args = { ... }
end)

return Shaders
