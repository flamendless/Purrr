local Component = require("modules.concord.lib.component")

local Ease = Component(function(e, ease)
	e.ease = ease
end)

return Ease
