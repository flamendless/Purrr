local Transition = {}

local log = require("modules.log.log")
local flux = require("modules.flux.flux")

local screen = require("src.screen")
local colors = require("src.colors")
local gamestate = require("src.gamestate")

function Transition:init()
	self.isActive = false
	self.overlays = {
		love.graphics.newImage("assets/images/overlay.png"),
	}
	for k,v in pairs(self.overlays) do v:setFilter(__filter, __filter) end
	self.current = self.overlays[1]
	self.canvas = love.graphics.newCanvas()
	self.duration = 0.75
	self.max_scale = screen.y/self.overlays[1]:getHeight() * 1.5
	self.scale = self.max_scale
	self.color = colors("flat", "black", "dark")
end

function Transition:start(next_state)
	self.current = self.overlays[1]
	self.isActive = true
	flux.to(self, self.duration, { scale = 0 })
		:ease("backout")
		:oncomplete(function()
				log.trace("State Changed!")
				gamestate:switch(next_state)
				self.current = self.overlays[1]
		end)
			:after(self, self.duration, { scale = self.max_scale })
			:oncomplete(function()
				log.trace("Transition Finished!")
				self.isActive = false
				-- gamestate:switch(next_state)
			end)
end

function Transition:draw()
	if not self.isActive then return end
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(self.color)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.draw(self.current, screen.x/2, screen.y/2, 0, self.scale, self.scale , self.current:getWidth()/2, self.current:getHeight()/2)
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()

	love.graphics.draw(self.canvas)
end

function Transition:getState() return self.isActive end

return Transition
