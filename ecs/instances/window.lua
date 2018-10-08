local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local S = require("ecs.systems")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local colors = require("src.colors")

local Window = {}

local dur = 0.75
local temp_window

function Window:load(spr_window, title, font)
	local sx = 4
	local sy = 4
	temp_window = __window
	__window = 2
	self.instance = ecs.instance()
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		position = S.position(),
	}

	self.entities = {}
	self.entities.main_window = ecs.entity()
		:give(C.color, colors(1, 1, 1, 1))
		:give(C.sprite, spr_window)
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.transform, 0, sx, sy, "center", "center")
		:give(C.windowIndex, __window)
		:apply()

	self.entities.title_text = ecs.entity()
		:give(C.window)
		:give(C.color, colors("flat", "white", "light"))
		:give(C.text, title, font, "center", spr_window:getWidth() * sx)
		:give(C.pos, vec2(0, 0))
		:give(C.parent, self.entities.main_window)
		:give(C.offsetPos, vec2(0, 64))
		:apply()

	self.instance:addEntity(self.entities.main_window)
	self.instance:addEntity(self.entities.title_text)

	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")

	self:start()
end

function Window:start()
	flux.to(self.entities.main_window[C.pos].pos, dur, { x = screen.x/2, y = screen.y/2 })
		:ease("backout")
end

function Window:update(dt)
	self.instance:emit("update", dt)
end

function Window:draw()
	self.instance:emit("draw")
end

function Window:keypressed(key)
	if key == "escape" then
		flux.to(self.entities.main_window[C.pos].pos, dur, { x = screen.x/2, y = -screen.y })
			:ease("backin")
			:oncomplete(function()
				gamestate:removeInstance(self.id)
			end)
	end
end

function Window:exit()
	self.instance:clear()
	__window = temp_window
end

return Window
