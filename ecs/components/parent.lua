local Component = require("modules.concord.lib.component")

local Parent = Component(function(e, parent)
	e.parent = parent
end)

return Parent
