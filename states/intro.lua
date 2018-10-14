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

local transition = require("src.transition")
local screen = require("src.screen")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")

function Intro:init()
	self.assets = {
		images = {
			{ id = "spritesheet", path = "assets/anim/space.png" }
		}
	}
	self.colors = {}
end

function Intro:enter(previous, ...)
	self.images = {
		spritesheet = resourceManager:getImage("spritesheet")
	}
	self.instance = ecs.instance()
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		position = S.position(),
	}

	local sx = screen.x/100
	local sy = screen.y/180
	local json = "assets/anim/space.json"
	local sheet = self.images.spritesheet

	self.entities = {}
	self.entities.intro1 = E.scene(ecs.entity(),
		json, sheet, "earth", true, nil, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(1) end }, true)
		:apply()

	self.entities.intro2 = E.scene(ecs.entity(),
		json, sheet, "spaceship1", true, 2, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(2) end }, true)
		:apply()

	self.entities.intro3 = E.scene(ecs.entity(),
		json, sheet, "snore", false, 1.25, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(3) end }, true)
		:apply()

	self.entities.intro4 = E.scene(ecs.entity(),
		json, sheet, "eyes", false, 1.25, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(4) end }, true)
		:apply()

	self.entities.intro5 = E.scene(ecs.entity(),
		json, sheet, "appear", true, nil, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(5) end }, true)
		:apply()

	self.entities.intro6 = E.scene(ecs.entity(),
		json, sheet, "exit", true, 2, sx, sy)
		:give(C.anim_callback, { onComplete = function() self:start(6) end }, true)
		:apply()

	self.instance:addSystem(self.systems.position)
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")

	self:start(0)
end

function Intro:start(n)
	if n == 0 then -- add earth
		self.instance:addEntity(self.entities.intro1)
	elseif n == 1 then -- add spaceship1, remove earth
		self.instance:removeEntity(self.entities.intro1)
		self.instance:addEntity(self.entities.intro2)
	elseif n == 2 then -- add snore, remove spaceship1
		self.instance:removeEntity(self.entities.intro2)
		self.instance:addEntity(self.entities.intro3)
	elseif n == 3 then -- add eyes, remove snore
		timer.after(2, function()
			self.instance:removeEntity(self.entities.intro3)
			self.instance:addEntity(self.entities.intro4)
		end)
	elseif n == 4 then -- add appear, remove eyes
		timer.after(2, function()
			self.instance:removeEntity(self.entities.intro4)
			self.instance:addEntity(self.entities.intro5)
		end)
	elseif n == 5 then -- add exit, remove appear
		self.instance:removeEntity(self.entities.intro5)
		self.instance:addEntity(self.entities.intro6)
	elseif n == 6 then -- remove exit
		timer.after(1, function()
			transition:start(function()
				self.instance:removeEntity(self.entities.intro6)
			end)
		end)
	end
end

function Intro:update(dt)
	self.instance:emit("update", dt)
end

function Intro:draw()
	self.instance:emit("draw")
end

function Intro:exit()
	self.instance:clear()
end

return Intro
