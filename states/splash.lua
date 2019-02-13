local BaseState = require("states.base_state")
local Splash = BaseState("Splash")

local lume = require("modules.lume.lume")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local vec2 = require("modules.hump.vector")
local timer = require("modules.hump.timer")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}

local S = require("ecs.systems")
local C = require("ecs.components")

local colors = require("src.colors")
local preload = require("src.preload")
local screen = require("src.screen")
local transition = require("src.transition")
local resourceManager = require("src.resource_manager")
local assets = require("src.assets")
local touch = require("src.touch")

local next_state = require("states.intro")
local delay = 0.5
local dur = 0.75

function Splash:enter(previous, ...)
	self.exiting = false
	self.colors = { bg = colors("flat", "blue", "dark") }
	self.instance = ecs.instance()
	self.images = {
		love_logo = resourceManager:getImage("love_logo"),
		love_text = resourceManager:getImage("love_text"),
		love_made_with = resourceManager:getImage("love_made_with"),
		touch_particle = resourceManager:getImage("touch_particle"),
	}
	touch:setup(self.images.touch_particle)
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		animation = S.animation(),
		renderer_sprite = S.renderer.sprite(),
		renderer_animation = S.renderer.animation(),
	}

	self.entities = {}
	self.entities.love_made_with = ecs.entity()
		:give(C.color)
		:give(C.sprite, self.images.love_made_with)
		:give(C.transform, vec2(screen.x/2, -screen.y/2), 0, 0.75, 0.75, self.images.love_made_with:getWidth()/2, self.images.love_made_with:getHeight()/2)
		:apply()

	self.entities.love_logo = ecs.entity()
		:give(C.color)
		:give(C.sprite, self.images.love_logo)
		:give(C.transform, vec2(-screen.x, screen.y/2), 0, 0.75, 0.75, self.images.love_logo:getWidth()/2, self.images.love_logo:getHeight()/2)
		:apply()

	self.entities.love_text = ecs.entity()
		:give(C.color)
		:give(C.sprite, self.images.love_text)
		:give(C.transform, vec2(screen.x/2, screen.y * 1.5), 0, 0.75, 0.75, self.images.love_text:getWidth()/2, self.images.love_text:getHeight()/2)
		:apply()

	self.instance:addEntity(self.entities.love_made_with)
	self.instance:addEntity(self.entities.love_logo)
	self.instance:addEntity(self.entities.love_text)

	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.renderer_sprite, "draw")
	self.instance:addSystem(self.systems.renderer_animation, "draw")

	flux.to(self.entities.love_made_with[C.transform].pos, dur, { y = screen.y * 0.15 }):ease("backout")
	flux.to(self.entities.love_logo[C.transform].pos, dur, { x = screen.x/2 }):ease("backout")
	flux.to(self.entities.love_text[C.transform].pos, dur, { y = screen.y * 0.85 }):ease("backout")
		:oncomplete(function()
			flux.to(self.entities.love_made_with[C.transform].pos, dur, { y = screen.y * 1.5 }):ease("backin"):delay(delay)
			flux.to(self.entities.love_logo[C.transform].pos, dur, { x = screen.x * 1.5 }):ease("backin"):delay(delay)
			flux.to(self.entities.love_text[C.transform].pos, dur, { y = -screen.y/2 }):ease("backin"):delay(delay)
				:oncomplete(function()
					transition:start(next_state)
				end)
		end)
end

function Splash:update(dt)
	self.instance:emit("update", dt)
end

function Splash:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

return Splash
