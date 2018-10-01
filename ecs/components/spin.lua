local Component = require("modules.concord.lib.component")

local Spin = Component(function(e, speed)
	e.speed = speed
end)

return Spin
