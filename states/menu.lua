local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local coil = require("modules.coil.coil")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local S = require("ecs.systems")
local C = require("ecs.components")

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
	}

	self.entities = {}
	self.entities.btn_play = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.button, "play", {
				text = "PLAY",
				font = self.fonts.button_42,
				textColor = colors("flat", "white", "light"),
				hoveredTextColor = colors("flat", "white", "dark"),
				normal = self.images.button,
				hovered = self.images.hovered_button
			})
		:give(C.maxScale, 1.25, 1.25)
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	self.instance:addEntity(self.entities.btn_play)

	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.tweenTo)
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "updatePosition")
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

	self:start()
end

function Menu:start()
	local dur = 1
	coil.add(function()
		flux.to(self.entities.btn_play[C.pos].pos, dur, { y = screen.y * 0.75 })
			:ease("backout")
			:oncomplete(function()
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
