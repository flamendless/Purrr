local Component = require("modules.concord.lib.component")

local ChangeColor = Component(function(e, dur)
	e.dur = dur
end)

return ChangeColor
