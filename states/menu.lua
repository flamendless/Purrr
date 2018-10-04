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
local resourceManager = require("src.resource_manager")

function Menu:init()
	self.assets = {
	}
	self.colors = {}
end

function Menu:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		renderer = S.renderer(),
	}
	self.entities = {}
	self.entities.test = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(128, 64))
		:apply()

	self.instance:addEntity(self.entities.test)

	-- self.instance:addSystem(self.systems.transform)
	-- self.instance:addSystem(self.systems.transform, "handleSprite")
	-- self.instance:addSystem(self.systems.transform, "handleAnim")
	-- self.instance:addSystem(self.systems.animation, "update")
	-- self.instance:addSystem(self.systems.animation, "draw")
	-- self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	-- self.instance:addSystem(self.systems.renderer, "draw", "drawText")
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.instance:emit("draw")
end

return Menu
