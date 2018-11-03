local Component = require("modules.concord.lib.component")

local BG = Component(function(e, sprite)
	e.sprite = sprite
end)

return BG
