local Component = require("modules.concord.lib.component")

local WindowIndex = Component(function(e, index)
	e.index = index or 1
end)

return WindowIndex
