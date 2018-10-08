local Component = require("modules.concord.lib.component")

local AttachToWindow = Component(function(e, window)
	e.window = window
end)

return AttachToWindow
