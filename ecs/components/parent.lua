local Component = require("modules.concord.lib.component")

local Parent = Component(function(e, parent, once)
	e.parent = parent
	e.once = (once == true) or false
end)

return Parent
