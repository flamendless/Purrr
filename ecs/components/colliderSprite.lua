local Component = require("modules.concord.lib.component")

local ColliderSprite = Component(function(e, canCollideWith)
	e.canCollideWith = canCollideWith
end)

return ColliderSprite
