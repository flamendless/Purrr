local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local lume = require("modules.lume.lume")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local data = require("src.data")
local transition = require("src.transition")
local event = require("src.event")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local assets = require("src.assets")
local pos = require("src.positions")

function Menu:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	self:start()
end

function Menu:setupSystems()
	self.systems = {
		collision = S.collision(),
		follow = S.follow(),
		gui = S.gui(),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
		position = S.position(),
		renderer = S.renderer(),
		transform = S.transform(),
		window_manager = S.window_manager(),
		textinput = S.textinput(),
	}

	self.instance:addSystem(self.systems.renderer, "draw", "drawBG")
	self.instance:addSystem(self.systems.textinput, "update")
	self.instance:addSystem(self.systems.textinput, "textinput")
	self.instance:addSystem(self.systems.textinput, "keypressed")
	self.instance:addSystem(self.systems.window_manager, "close")
	self.instance:addSystem(self.systems.window_manager, "changeWindowTitle")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "mousepressed")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.gui, "changeSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.collision, "draw", "draw")
end

function Menu:setupEntities()
	if data.data.new_game then next_state = require("states.intro")
	else
		if data.data.customization then next_state = require("states.customization")
		else next_state = require("states.lobby")
		end
	end
	self.entities = {}
	self.entities.bg = E.title_bg(ecs.entity())
	self.entities.btn_play = E.button_play(ecs.entity(), next_state)
	self.entities.btn_quit = E.button_quit(ecs.entity(), self.entities.btn_play)
		:give(C.offsetPos, pos.menu.quit:clone()):apply()
	self.entities.settings = E.button_settings(ecs.entity())
	self.entities.title = E.title(ecs.entity())

	self.instance:addEntity(self.entities.bg)
	self.instance:addEntity(self.entities.btn_play)
	self.instance:addEntity(self.entities.btn_quit)
	self.instance:addEntity(self.entities.title)
	self.instance:addEntity(self.entities.settings)
end

function Menu:start()
	local dur = 1
	flux.to(self.entities.title[C.pos].pos, dur, { y = pos.menu.title:clone().y }):ease("backout")
	flux.to(self.entities.settings[C.pos].pos, dur, { x = pos.menu.settings:clone().x, y = pos.menu.settings:clone().y })
	flux.to(self.entities.btn_play[C.pos].pos, dur, { y = pos.menu.play:clone().y })
		:ease("backout")
		:oncomplete(function()
			self.entities.btn_quit:remove(C.follow):apply()
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
		end)
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.instance:emit("draw")
end

function Menu:keypressed(key)
	self.instance:emit("keypressed", key)
	if key == "escape" then
		if event.isOpen then
			self.instance:emit("close")
		else
			event:showExitConfirmation()
		end
	end
end

function Menu:mousepressed(mx, my, mb)
	self.instance:emit("mousepressed", mx, my, mb)
end

function Menu:textinput(t)
	self.instance:emit("textinput", t)
end

function Menu:exit()
	if self.instance then self.instance:clear() end
end

return Menu
