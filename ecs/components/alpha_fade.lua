local Component = require("modules.concord.lib.component")

local AlphaFade = Component(function(e, loop)
	e.loop = (loop == true) or false
end)

return AlphaFade
