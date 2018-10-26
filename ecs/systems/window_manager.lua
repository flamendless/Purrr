local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")
local screen = require("src.screen")

local WindowManager = System({
	C.window,
	C.pos,
}, {
	C.windowButton,
	C.button,
	"buttons"
})

local dur = 0.75

function WindowManager:entityAddedTo(e, pool)
	__window = 2
	if pool.name == "buttons" then
		e[C.windowButton].index = __window
	else
		flux.to(e[C.pos].pos, dur, { y = screen.y/2 })
			:ease("backout")
	end
end

function WindowManager:close()
	for _,e in ipairs(self.pool) do
		flux.to(e[C.pos].pos, dur, { y = screen.y * 2 })
			:ease("backin")
			:oncomplete(function()
				__window = 1
			end)
	end
end

return WindowManager
