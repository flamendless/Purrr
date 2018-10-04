local Component = require("modules.concord.lib.component")

local AnimCallback = Component(function(e, cb)
	e.callback = cb
end)

return AnimCallback
