local Transition = {}

local log = require("modules.log.log")
local flux = require("modules.flux.flux")

local screen = require("src.screen")
local soundManager = require("src.sound_manager")
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
	self.pos_x = -screen.x
end

function Transition:start(next_state, d)
	self.current = self.overlays[1]
	self.isActive = true
	soundManager:send("transition")
	if love.system.getOS() == "Android" then
		self.pos_x = -screen.x
		flux.to(self, d or self.duration, { pos_x = 0 })
			:oncomplete(function()
					log.trace("State Changed!")
					if type(next_state) == "function" then
						next_state()
					else
						gamestate:switch(next_state)
					end
			end)
				:after(self, d or self.duration * 2, { pos_x = screen.x })
				:oncomplete(function()
					log.trace("Transition Finished!")
					self.isActive = false
					-- gamestate:switch(next_state)
				end)
	else

		flux.to(self, d or self.duration, { scale = 0 })
			:ease("backout")
			:oncomplete(function()
					log.trace("State Changed!")
					if type(next_state) == "function" then
						next_state()
					else
						gamestate:switch(next_state)
						self.current = self.overlays[1]
					end
			end)
				:after(self, d or self.duration, { scale = self.max_scale })
				:oncomplete(function()
					log.trace("Transition Finished!")
					self.isActive = false
					-- gamestate:switch(next_state)
				end)
	end
end

function Transition:draw()
	if not self.isActive then return end
	if love.system.getOS() == "Android" then
		if self.color and self.color.set then
			self.color:set()
		else
			love.graphics.setBackgroundColor(self.color)
		end
		love.graphics.rectangle("fill", self.pos_x, 0, screen.x, screen.y)
	else
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(self.color)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.draw(self.current, screen.x/2, screen.y/2, 0, self.scale, self.scale , self.current:getWidth()/2, self.current:getHeight()/2)
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
		love.graphics.draw(self.canvas)
	end
end

function Transition:getState() return self.isActive end

return Transition
