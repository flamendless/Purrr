local BaseState = require("states.base_state")
local Intro = BaseState("Intro")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")
local peachy = require("modules.peachy.peachy")
local vec2 = require("modules.hump.vector")
local timer = require("modules.hump.timer")

local data = require("src.data")
local transition = require("src.transition")
local screen = require("src.screen")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local next_state = require("states.customization")

function Intro:init()
end

function Intro:enter(previous, ...)
	self.images = {
		spritesheet = resourceManager:getImage("spritesheet")
	}
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
end

function Intro:setupSystems()
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		position = S.position(),
	}
	self.instance:addSystem(self.systems.position)
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
end

function Intro:setupEntities()
	local sx = screen.x/100
	local sy = screen.y/180
	local json = "assets/anim/json/space.json"
	local sheet = self.images.spritesheet
	self.entities = {}
	self.entities.intro = E.scene(ecs.entity(),
		json, sheet, "default", true, nil, sx, sy)
		:give(C.anim_callback, {
			onComplete = function()
				timer.after(1, function()
					data.data.new_game = false
					transition:start(next_state)
				end)
			end }, true)
		:apply()
	self.instance:addEntity(self.entities.intro)
end

function Intro:update(dt)
	self.instance:emit("update", dt)
end

function Intro:keypressed(key)
	if __debug and key == "space" then
		data.data.new_game = false
		transition:start(next_state)
	end
end

function Intro:draw()
	self.instance:emit("draw")
end

function Intro:exit()
	if self.instance then self.instance:clear() end
end

return Intro
