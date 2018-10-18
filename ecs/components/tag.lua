local Component = require("modules.concord.lib.component")

local Tag = Component(function(e, tag)
	e.tag = tag
end)

return Tag
