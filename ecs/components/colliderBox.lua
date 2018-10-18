local Component = require("modules.concord.lib.component")

local ColliderBox = Component(function(e, size, canCollideWith)
	e.size = size
	e.canCollideWith = canCollideWith
end)

return ColliderBox
