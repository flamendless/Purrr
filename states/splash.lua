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
local gamestate = require("src.gamestate")
local resourceManager = require("src.resource_manager")
local assets = require("src.assets")

local next_state = require("states.menu")
local delay = 1
local speed = 2
if __debug then delay = 0 speed = 8 end

function Splash:enter(previous, ...)
	self.exiting = false
	self.colors = {
		bg = colors("black"),
		logo = colors("white"),
		text = colors("flat", "white", "light"),
	}
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
	}

	self.entities = {}
	self.entities.logo = ecs.entity()
		:give(C.color, self.colors.logo)
		:give(C.anim, "assets/anim/json/flamendless.json", self.images.flamendless, {
				speed = speed,
				stopOnLast = true,
			})
		:give(C.pos, vec2(screen.x/2, screen.y/2 + 64))
		:give(C.transform, 0, 4, 4, "center", "bottom")
		:give(C.anim_callback, {
				onComplete = function()
					flux.to(self.colors.logo, delay, { [4] = 0 })
					flux.to(self.colors.text, delay, { [4] = 0 })
					timer.after(delay, function()
						if not self.exiting then
							self.exiting = true
							transition:start(next_state)
						end
					end)
				end
			})
		:apply()

	self.entities.text = ecs.entity()
		:give(C.color, self.colors.text)
		:give(C.text, "flamendless", self.fonts.bmdelico_42, "center", screen.x)
		:give(C.pos, vec2(0, screen.y/2 + 128))
		:apply()

	self.instance:addEntity(self.entities.logo)
	self.instance:addEntity(self.entities.text)

	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
end

function Splash:update(dt)
	self.instance:emit("update", dt)
end

function Splash:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

function Splash:mousepressed(mx, my, mb)
	if not self.exiting then
		self.exiting = true
		transition:start(next_state)
	end
end

return Splash
