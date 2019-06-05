local Types = {}

local ecs_types = require("modules.concord.lib.type")

function Types.isGUIButton(e)
	return e.__isGUIButton
end

Types.isEntity = ecs_types.isEntity

return Types
