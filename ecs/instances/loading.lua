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
	self.colors = { loading = colors("random-flat") }
	self.images = {}
	if not resourceManager:check("images", "loading") then
		self.images.cat = love.graphics.newImage("assets/anim/preload.png")
		resourceManager:add("images", "cat", self.images.cat)
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
		:give(C.anim, "assets/anim/json/preload.json", self.images.cat)
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 2, 2, "center", "center")
		:apply()

	self.instance:addEntity(self.entities.loading)

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
