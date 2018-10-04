local Component = require("modules.concord.lib.component")

local OffsetPos = Component(function(e, offset)
	e.offset = offset
end)

return OffsetPos
