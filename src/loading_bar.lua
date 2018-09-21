local class = require("modules.classic.classic")
local flux = require("modules.flux.flux")

local LoadingBar = class:extend()

function LoadingBar:new(x, y, w, h, roundness, speed)
	self.percent = 0
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.roundness = roundness
	self.speed = speed or 1
	self.bar = 0
	self.lerp = false
	self.isDone = false
	if __debug then
		self.speed = 0.1
	end
end

function LoadingBar:update(percent)
	-- self.bar = self.percent/100 * self.w
	if not self.isDone then
		if not self.lerp then
			self.lerp = true
			self.percent = percent
			flux.to(self, self.speed, { bar = self.percent/100 * self.w })
				:oncomplete(function() self.lerp = false end)
		end
	end
	self.isDone = self.bar >= self.w
end

function LoadingBar:draw()
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness)
	love.graphics.rectangle("fill", self.x, self.y, self.bar, self.h, self.roundness)
end

return LoadingBar
