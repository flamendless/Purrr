local Component = require("modules.concord.lib.component")

local HoveredSprite = Component(function(e, sprite)
	e.sprite = sprite
	e.state = false
end)

return HoveredSprite
