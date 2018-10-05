local Component = require("modules.concord.lib.component")

local ColliderBox = Component(function(e, canCollideWith)
	e.canCollideWith = canCollideWith
end)

return ColliderBox
