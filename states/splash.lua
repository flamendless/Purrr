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
end

function Splash:update(dt)
	self.instance:emit("update", dt)
end

function Splash:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
end

return Splash
