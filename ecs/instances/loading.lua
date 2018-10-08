local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}

local S = require("ecs.systems")
local C = require("ecs.components")

local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

local Loading = {}

function Loading:load()
	self.colors = {
		loading = colors("random-flat"),
		eyes = colors("random-flat"),
		nose = colors("random-flat")
	}
	self.images = {}
	if not resourceManager:check("images", "loading") then
		self.images.loading = love.graphics.newImage("assets/anim/loading.png")
		self.images.eyes = love.graphics.newImage("assets/parts/eyes.png")
		self.images.nose = love.graphics.newImage("assets/parts/nose.png")
		resourceManager:add("images", "loading", self.images.loading)
		resourceManager:add("images", "eyes", self.images.eyes)
		resourceManager:add("images", "nose", self.images.nose)
		for k,v in pairs(self.images) do v:setFilter("nearest", "nearest") end
	else
		self.images = resourceManager:getAll("images")
	end

	self.instance = ecs.instance()
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		position = S.position(),
		patrol = S.patrol(),
		moveTo = S.moveTo(),
		follow = S.follow(),
	}

	self.entities = {}
	self.entities.loading = ecs.entity()
		:give(C.color, self.colors.loading)
		:give(C.anim, "assets/anim/loading.json", self.images.loading)
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 3, 3, "center", "center")
		:apply()

	self.entities.eyes = ecs.entity()
		:give(C.pos, vec2())
		:give(C.parent, self.entities.loading, true)
		:give(C.color, self.colors.eyes)
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.sprite, self.images.eyes)
		:give(C.patrol, {
				vec2(0, -8),
				vec2(0, 8),
			}, true)
		:give(C.speed, vec2(0, 32))
		:apply()

	self.entities.nose = ecs.entity()
		:give(C.pos, vec2())
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.parent, self.entities.eyes, true)
		:give(C.color, self.colors.nose)
		:give(C.sprite, self.images.nose)
		:give(C.follow, self.entities.eyes)
		:give(C.offsetPos, vec2(0, 12))
		:apply()

	self.instance:addEntity(self.entities.loading)
	self.instance:addEntity(self.entities.eyes)
	self.instance:addEntity(self.entities.nose)

	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.position)
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
end

function Loading:update(dt)
	self.instance:emit("update", dt)
end

function Loading:draw()
	self.instance:emit("draw")
end

return Loading
