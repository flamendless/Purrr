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
		}
	}
	self.colors = {}
end

function Menu:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.imageData = resourceManager:getAll("ImageData")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		gui = S.gui(),
		collision = S.collision(),
	}

	self.entities = {}
	self.entities.test = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.button, "test", {
				normal = self.images.test,
				hovered = self.images.test2,
			})
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	self.instance:addEntity(self.entities.test)

	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "checkPoint")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	-- self.instance:addSystem(self.systems.transform, "handleAnim")
	-- self.instance:addSystem(self.systems.animation, "update")
	-- self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	-- self.instance:addSystem(self.systems.renderer, "draw", "drawText")
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.instance:emit("draw")
end

return Menu
