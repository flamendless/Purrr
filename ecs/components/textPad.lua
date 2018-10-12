local Component = require("modules.concord.lib.component")

local TextPad = Component(function(e, pad)
	e.pad = pad
end)

return TextPad
