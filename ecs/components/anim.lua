local Component = require("modules.concord.lib.component")

local Anim = Component(function(e, json, sheet, args)
	e.json = json
	e.sheet = sheet
	e.tag = "default"
	e.args = args
	if args then
		e.tag = args.tag or "default"
		e.speed = args.speed or 1
		e.stopOnLast = args.stopOnLast
	end
end)

return Anim
