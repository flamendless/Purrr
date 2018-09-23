local BaseState = require("states.base_state")
local Splash = BaseState("Splash")

local log = require("modules.log.log")
local ecs = {
	instance = require("modules.concord.lib.instance")
}

local colors = require("src.colors")
local preload = require("src.preload")
local screen = require("src.screen")
local transition = require("src.transition")
local gamestate = require("src.gamestate")
local resourceManager = require("src.resource_manager")

function Splash:init()
	self.assets = {
		images = {
			{ id = "logo_love", path = "assets/images/logo_love.png" },
			{ id = "logo_flam", path = "assets/images/flamendless.png" },
		},
		fonts = {
			{ id = "vera", path = "assets/fonts/vera.ttf", sizes = { 18, 24, 32 } }
		}
	}
	self.colors = {
		bg = colors("flat", "black", "dark")
	}
end

function Splash:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = {
		flamendless = resourceManager:getImage("logo_flam"),
	}
end

function Splash:update(dt)
	self.instance:emit("update", dt)
end

function Splash:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.images.flamendless)
end

function Splash:keypressed(key)
	if key == "space" then
		gamestate:switch(self, "hi", "hello")
	end
end

return Splash
