local Component = require("modules.concord.lib.component")

local BG = Component(function(e, bg)
	assert(bg:type() == "Image", "BG must be an image")
	e.bg = bg
end)

return BG
