local Component = require("modules.concord.lib.component")

local OnClick = Component(function(e, cb)
	e.onClick = cb
end)

return OnClick
