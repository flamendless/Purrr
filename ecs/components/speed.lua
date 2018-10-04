local Component = require("modules.concord.lib.component")

local Speed = Component(function(e, speed)
	e.speed = speed
	e.orig_speed = e.speed:clone()
end)

return Speed
