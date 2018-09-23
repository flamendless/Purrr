local Component = require("modules.concord.lib.component")

local Tween = Component(function(e, dur, delay, ease)
	e.dur = dur or 0.2
	e.delay = delay or 0
	e.ease = ease
end)

return Tween
