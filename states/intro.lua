local BaseState = require("base.state")
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

local bgm = require("src.bgm")
local config = require("src.config")
local transition = require("src.transition")
local screen = require("src.screen")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")

local next_state

function Intro:enter(previous, ...)
	self.images = {
		spritesheet_intro = resourceManager:getImage("spritesheet_intro")
	}
	self.sources = resourceManager:getAll("sources")
	self.font = resourceManager:getFont("fnt_skip_24")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	bgm:start(self.sources.bgm_intro, "Intro")
end

function Intro:setupSystems()
	self.systems = {
		animation = S.animation(),
		alpha_fade = S.alpha_fade(),
		renderer_animation = S.renderer.animation(),
		renderer_text = S.renderer.text(),
		collider = S.collider(),
	}

	if __isDesktop then self.instance:addSystem(self.systems.collider, "mousepressed")
	elseif __isMobile then self.instance:addSystem(self.systems.collider, "touchpressed")
	end
	self.instance:addSystem(self.systems.alpha_fade)
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.renderer_animation, "draw")
	self.instance:addSystem(self.systems.renderer_text, "draw")

	if __debug then
		self.instance:addSystem(self.systems.collider, "draw")
	end
end

function Intro:setupEntities()
	local sx = screen.x/100
	local sy = screen.y/180
	local obj_anim = peachy.new("assets/anim/json/space.json", self.images.spritesheet_intro, "default")
	obj_anim:onLoop(function()
		obj_anim:stop(true)
		timer.after(1, function()
			next_state = require("states").lobby
			transition:start(next_state)
		end)
	end)
	local str_skip
	if __isDesktop then str_skip = "Press Space To Skip"
	elseif __isMobile then str_skip = "Touch To Skip"
	end
	self.entities = {}
	self.entities.intro = ecs.entity()
		:give(C.color)
		:give(C.animation, obj_anim)
		:give(C.transform, vec2(), 0, sx, sy)
		:give(C.collider_rect, vec2(obj_anim:getWidth() * 100, obj_anim:getHeight() * 180))
		:apply()

	self.entities.text = ecs.entity()
		:give(C.tag, "Button Skip")
		:give(C.color, {1, 0, 0, 1})
		:give(C.text, str_skip)
		:give(C.font, self.font)
		:give(C.transform, vec2(screen.x/2 - self.font:getWidth(str_skip)/2, screen.y - 32 - self.font:getHeight(str_skip)))
		:give(C.alpha_fade, true)
		:give(C.fade_state, "out", 1)
		:give(C.collider_rect, vec2(self.font:getWidth(str_skip), self.font:getHeight(str_skip)))
		:apply()

	self.instance:addEntity(self.entities.intro)
	self.instance:addEntity(self.entities.text)
end

function Intro:update(dt)
	self.instance:emit("update", dt)
end

function Intro:keypressed(key)
	if __debug and key == "space" then
		transition:start(next_state)
	end
end

function Intro:touchpressed(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchpressed", id, tx, ty, dx, dy, pressure)
end

function Intro:mousepressed(mx, my, mb)
	self.instance:emit("mousepressed", mx, my, mb)
end

function Intro:draw()
	self.instance:emit("draw")
end

function Intro:exit()
	bgm:clear()
	if self.instance then self.instance:clear() end
end

return Intro
