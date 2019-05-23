local BaseState = require("states.base_state")
local Customization = BaseState("Customization")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local timer = require("modules.hump.timer")
local lume = require("modules.lume.lume")

local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local config = require("src.config")
local transition = require("src.transition")
local assets = require("src.assets")
local pos = require("src.positions")

local next_state
local level = 1

function Customization:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	if not config.data.got_name then
		event:getName()
		self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
	else
		self:start()
	end
end

function Customization:setupSystems()
	self.systems = {
		collider = S.collider(),
		renderer_sprite = S.renderer.sprite(),
		collider = S.collider(),
		gui = S.gui(),
	}

	if __isDesktop then
		self.instance:addSystem(self.systems.collider, "mousepressed")
		self.instance:addSystem(self.systems.gui, "mousepressed")
	elseif __isMobile then
		self.instance:addSystem(self.systems.collider, "touchpressed")
		self.instance:addSystem(self.systems.gui, "touchpressed")
	end

	self.instance:addSystem(self.systems.renderer_bg, "draw")
	self.instance:addSystem(self.systems.renderer_sprite, "draw")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "mousepressed")

	if __debug then
		self.instance:addSystem(self.systems.collider, "draw")
	end
end

function Customization:setupEntities(tag)
end

function Customization:start()
end

function Customization:update(dt)
	self.instance:emit("update", dt)
end

function Customization:draw()
	self.instance:emit("draw")
end

function Customization:keypressed(key)
	self.instance:emit("keypressed", key)
end

function Customization:mousepressed(mx, my, mb)
	self.instance:emit("mousepressed", mx, my, mb)
end

function Customization:touchreleased(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchreleased", id, tx, ty, dx, dy, pressure)
end

function Customization:textinput(t)
	self.instance:emit("textinput", t)
end

function Customization:exit()
	if self.instance then self.instance:clear() end
	config.data.flags.customization_done = false
	config.data.flags.new_game = false
	config.data.flags.has_name = true
	config:save()
end

return Customization
