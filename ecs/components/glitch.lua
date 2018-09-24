local Component = require("modules.concord.lib.component")

local Glitch = Component(function(e, dur)
	e.dur = dur or 0
end)

return Glitch
