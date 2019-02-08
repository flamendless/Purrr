local Component = require("modules.concord.lib.component")

local onHoveredSprite = Component(function(e, sprite)
	assert(sprite:type() == "Image", "sprite must be an image")
	e.sprite = sprite
	e.isActive = false
end)

return onHoveredSprite
