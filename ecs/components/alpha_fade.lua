local Component = require("modules.concord.lib.component")

local AlphaFade = Component(function(e, loop)
	e.loop = (loop == true) or false
end)

function AlphaFade:debug()
	if imgui.TreeNodeEx("Alpha Fade", __flags_tree) then
		imgui.Text("Loop: " .. tostring(self.loop))
		imgui.TreePop()
	end
end

return AlphaFade
