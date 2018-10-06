local Component = require("modules.concord.lib.component")

local MaxScale = Component(function(e, sx, sy)
	e.max_sx = sx
	e.max_sy = sy
end)

return MaxScale
