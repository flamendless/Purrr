local Component = require("modules.concord.lib.component")

local Sync = Component(function(e, parent)
	e.parent = parent
end)

return Sync
