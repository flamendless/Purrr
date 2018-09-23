local Component = require("modules.concord.lib.component")

local Text = Component(function(e, text, font, align, limit)
	e.text = text
	e.font = font
	e.align = align
	e.limit = limit
end)

return Text
