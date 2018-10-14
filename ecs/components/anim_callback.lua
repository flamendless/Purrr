local Component = require("modules.concord.lib.component")

local AnimCallback = Component(function(e, cb, volatile)
	e.callback = cb
	e.volatile = volatile
end)

return AnimCallback
