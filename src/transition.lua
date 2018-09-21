local Transition = {}

local log = require("modules.log.log")
local flux = require("modules.flux.flux")
local gamestate = require("modules.hump.gamestate")

local screen = require("src.screen")
local colors = require("src.colors")

function Transition:init()
	self.isActive = false
	self.overlay = love.graphics.newImage("assets/images/overlay.png")
	self.overlay:setFilter(__filter, __filter)
	self.canvas = love.graphics.newCanvas()
	self.duration = 1.25
	self.max_scale = screen.y/self.overlay:getHeight() * 1.5
	self.scale = self.max_scale
end

function Transition:start(next_state)
	self.isActive = true
	flux.to(self, self.duration, { scale = 0 })
		:ease("backout")
		:after(self, self.duration, { scale = self.max_scale })
		:ease("backin")
		:oncomplete(function()
			log.trace("Transition Finished!")
			self.isActive = false
			gamestate.switch(next_state)
		end)
end

function Transition:draw()
	if not self.isActive then return end
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0, 0, 0, 1)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.draw(self.overlay, screen.x/2, screen.y/2, 0, self.scale, self.scale , self.overlay:getWidth()/2, self.overlay:getHeight()/2)
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()

	love.graphics.draw(self.canvas)
end

function Transition:getState() return self.isActive end

return Transition
