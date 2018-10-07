local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local coil = require("modules.coil.coil")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local event = require("src.event")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

function Menu:init()
	self.assets = {
		images = {
			{ id = "button", path = "assets/gui/button_yellow.png" },
			{ id = "hovered_button", path = "assets/gui/button_yellow_hovered.png" },
		},
		fonts = {
			{ id = "button", path = "assets/fonts/upheavalpro.ttf", sizes = {28, 32, 36, 42}  }
		}
	}
	self.colors = {
		bg = colors("flat", "black", "dark"),
	}
end

function Menu:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		gui = S.gui(),
		collision = S.collision(),
		tweenTo = S.tweenTo(),
		follow = S.follow(),
		patrol = S.patrol(),
		moveTo = S.moveTo(),
		position = S.position(),
	}

	self.entities = {}
	self.entities.btn_play = E.button(ecs.entity(), "play",
		vec2(screen.x/2, screen.y * 1.5),
		{
			text = "PLAY",
			font = self.fonts.button_42,
			textColor = colors("flat", "white", "light"),
			hoveredTextColor = colors("flat", "white", "dark"),
			normal = self.images.button,
			hovered = self.images.hovered_button,
			onClick = function()

			end
		})
		:apply()

	self.entities.btn_quit = E.button(ecs.entity(), "quit",
		vec2(screen.x/2, screen.y * 1.75),
		{
			text = "QUIT",
			font = self.fonts.button_42,
			textColor = colors("flat", "white", "light"),
			hoveredTextColor = colors("flat", "white", "dark"),
			normal = self.images.button,
			hovered = self.images.hovered_button,
			onClick = function()
				event.showExitConfirmation()
			end
		})
		:give(C.follow, self.entities.btn_play)
		:give(C.offsetPos, vec2(0, 128))
		:apply()

	self.instance:addEntity(self.entities.btn_play)
	self.instance:addEntity(self.entities.btn_quit)

	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.tweenTo)
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.collision, "draw", "draw")

	self:start()
end

function Menu:start()
	local dur = 1
	coil.add(function()
		flux.to(self.entities.btn_play[C.pos].pos, dur, { y = screen.y * 0.75 })
			:ease("backout")
			:oncomplete(function()
				self.entities.btn_quit:remove(C.follow):apply()
				self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
			end)
	end)
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

return Menu
