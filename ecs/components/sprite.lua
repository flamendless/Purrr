local Component = require("modules.concord.lib.component")

local Sprite = Component(function(e, sprite)
	assert(sprite:type() == "Image", "Sprite must be an image")
	e.sprite = sprite
end)

return Sprite
