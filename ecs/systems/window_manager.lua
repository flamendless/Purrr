local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local screen = require("src.screen")
local event = require("src.event")
local gamestate = require("src.gamestate")

local WindowManager = System({
	C.window,
	C.pos,
}, {
	C.windowButton,
	C.button,
	"buttons"
}, {
	C.windowTitle,
	"title"
})

local dur = 0.75

function WindowManager:init()
	self.window_title = nil
end

function WindowManager:entityAddedTo(e, pool)
	__window = 2
	if pool.name == "buttons" then
		e[C.windowButton].index = __window
	elseif pool.name == "title" then
		if self.window_title then
			log.warn("Window Title already exists!")
		end
		self.window_title = e
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
				event.isOpen = false
			end)
	end
end

function WindowManager:changeWindowTitle(str)
	self.window_title[C.text].text = str
end

return WindowManager
