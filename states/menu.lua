local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

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
			{ id = "test", path = "assets/gui/9patch_blue.png" },
			{ id = "test2", path = "assets/gui/9patch_yellow.png" }
		},
		fonts = {
			{ id = "vera", path = "assets/fonts/vera.ttf", sizes = { 18, 24, 32 } },
			{ id = "bmdelico", path = "assets/fonts/bmdelico.ttf", sizes = { 18, 24, 32, 42 } },
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
	}

	local dur = 1
	self.entities = {}
	self.entities.test = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.tween, dur, 0.5, "backout")
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.targetPos, vec2(screen.x/2, screen.y/2))
		:give(C.button, "test", {
				text = "PLAY",
				font = self.fonts.vera_32,
				textColor = colors("red"),
				normal = self.images.test,
				hovered = self.images.test2,
			})
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()
	-- self.entities.btn_play = ecs.entity()
	-- 	:give()

	self.instance:addEntity(self.entities.test)

	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.tweenTo)
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

return Menu
