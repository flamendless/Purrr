local Component = require("modules.concord.lib.component")

local Text = Component(function(e, text)
	assert(type(text) == "string", "argument text must be a string")
	e.text = text
end)

return Text
