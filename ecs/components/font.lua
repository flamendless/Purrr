local Component = require("modules.concord.lib.component")

local Font = Component(function(e, font)
	assert(font:type() == "Font", "argument font must be a font")
	e.font = font
end)

return Font
