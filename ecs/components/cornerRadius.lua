local Component = require("modules.concord.lib.component")

local CornerRadius = Component(function(e, size)
	e.size = size
	e.orig_size = size
end)

return CornerRadius
