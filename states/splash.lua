local BaseState = require("states.base_state")
local Splash = BaseState("Splash")

local lume = require("modules.lume.lume")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local vec2 = require("modules.hump.vector")
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

local next_state = require("states.menu")
local s1

function Splash:init()
	self.assets = {
		images = {
			{ id = "logo_flam", path = "assets/images/flamendless.png" },
		},
		fonts = {
			{ id = "vera", path = "assets/fonts/vera.ttf", sizes = { 18, 24, 32 } }
		}
	}
	self.colors = {
		bg = colors("flat", "black", "dark"),
		logo = colors("flat", "white", "dark"),
	}
end

function Splash:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		renderer = S.renderer(),
		transform = S.transform(),
		glitchEffect = S.glitchEffect(),
	}

	self.entities = {}
	self.entities.logo = ecs.entity()
		:give(C.glitch, 2)
		:give(C.color, self.colors.logo, 0)
		:give(C.sprite, self.images.logo_flam)
		:give(C.pos, vec2(screen.x/2, screen.y/2 + 64))
		:give(C.transform, 0, 1, 1, "center", "bottom")
		:apply()

	self.entities.text = ecs.entity()
		:give(C.color, self.colors.logo, 0)
		:give(C.text, "flamendless", self.fonts.vera_32, "center", screen.x)
		:give(C.pos, vec2(0, screen.y/2 + 128))
		:apply()

	self.instance:addEntity(self.entities.logo)
	self.instance:addEntity(self.entities.text)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.glitchEffect, "update")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")

	--sequence
	s1 = flux.to(self.colors.logo, 2, { [4] = 1 }):delay(0.25)
		:oncomplete(function()
			transition:start(next_state)
		end)
end

function Splash:update(dt)
	self.instance:emit("update", dt)
end

function Splash:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

function Splash:mousepressed(mx, my, mb)
	transition:start(next_state)
	if s1 then
		s1:stop()
	end
end

return Splash
