local Component = require("modules.concord.lib.component")

local OnHover = Component(function(e, func)
	e.onHover = func
end)

return OnHover
