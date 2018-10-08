local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Windows = System({
		C.window,
	})

return Windows
