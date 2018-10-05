local Component = require("modules.concord.lib.component")

local Patch = Component(function(e, image, size)
	e.image = image
	e.size = size
end)

return Patch
