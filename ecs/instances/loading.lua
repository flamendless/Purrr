local Instance = require("modules.concord.lib.instance")
local Entity = require("modules.concord.lib.entity")

local S = require("ecs.systems")
local C = require("ecs.components")

local peachy = require("modules.peachy.peachy")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

local Loading = {}

function Loading:load()
	self.color = colors("random-flat")
	self.source = resourceManager:getPersistent("sfx_transition")
	if self.source then
		self.source:play()
	end
	self.image = resourceManager:getPersistent("loading")
	self.instance = Instance()
	self.systems = {
		animation = S.animation(),
		renderer_animation = S.renderer.animation(),
	}

	if self.image then
		local obj_anim = peachy.new("assets/anim/json/preload.json", self.image, "default")
		self.ent_loading = Entity()
			:give(C.color, self.color)
			:give(C.animation, obj_anim)
			:give(C.transform, vec2(screen.x/2, screen.y/2), 0, 2, 2, obj_anim:getWidth()/2, obj_anim:getHeight()/2)
			:apply()

		self.instance:addEntity(self.ent_loading)
		self.instance:addSystem(self.systems.animation, "update")
		self.instance:addSystem(self.systems.renderer_animation, "draw")
	end
end

function Loading:update(dt)
	self.instance:emit("update", dt)
end

function Loading:draw()
	self.instance:emit("draw")
end

function Loading:exit()
	self.instance:emit("exit")
end

return Loading
