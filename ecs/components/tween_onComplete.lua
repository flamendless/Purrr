local Component = require("modules.concord.lib.component")

local TweenOnComplete = Component(function(e, fn)
	e.fn = fn
end)

return TweenOnComplete
