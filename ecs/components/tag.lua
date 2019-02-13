local Component = require("modules.concord.lib.component")

local Tag = Component(function(e, tag)
	assert(tag, "Tag must be a string")
	e.tag = tag
end)

function Tag:debug()
	imgui.Text("Tag: " .. self.tag)
end

return Tag
