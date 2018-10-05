local Component = require("modules.concord.lib.component")

local Follow = Component(function(e, target)
	e.target = target
end)

return Follow
