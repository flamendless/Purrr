local Component = require("modules.concord.lib.component")

local GUIOnClick = Component(function(e, callback)
	assert(type(callback) == "function", "callback must be a function")
	e.callback = callback
end)

return GUIOnClick
