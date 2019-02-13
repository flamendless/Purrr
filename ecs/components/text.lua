local Component = require("modules.concord.lib.component")

local Text = Component(function(e, text)
	assert(type(text) == "string", "argument text must be a string")
	e.text = text
end)

function Text:debug()
	if imgui.TreeNodeEx("Text", __flags_tree) then
		imgui.InputText("", self.text, #self.text)
		imgui.TreePop()
	end
end

return Text
