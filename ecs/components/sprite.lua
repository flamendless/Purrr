local Component = require("modules.concord.lib.component")

local Sprite = Component(function(e, sprite)
	e.sprite = sprite
end)

return Sprite
