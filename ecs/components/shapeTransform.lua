local Component = require("modules.concord.lib.component")

local ShapeTransform = Component(function(e, dur)
	e.dur = dur
end)

return ShapeTransform
