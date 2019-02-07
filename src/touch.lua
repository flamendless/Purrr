local Touch = {
	state = false,
	list = {},
	ps,
}

local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local screen = require("src.screen")
local colors = require("src.colors")

local rad = math.rad

function Touch:init()
	if not (love.system.getOS() == "Android") then
		log.info("Touch initialized... using mouse simulation")
	else
		log.info("Touch initialized... using real touch")
	end
end

function Touch:setup(img)
	local speed = 60
	self.ps = love.graphics.newParticleSystem(img, 8)
	self.ps:setParticleLifetime(1, 3)
	self.ps:setSizeVariation(1)
	self.ps:setLinearAcceleration(-speed, -speed, speed, speed)
	self.ps:setSpread(rad(90))
	self.ps:setEmissionArea("normal", 16, 16, 45, true)
	local color1 = colors:flat("blue", "light")
	local color2 = colors:flat("teal", "light")
	local color3 = colors:flat("violet", "light")
	self.ps:setColors(color1, color2, color3)
end

function Touch:update(dt)
	if self.ps then self.ps:update(dt) end
	if love.system.getOS() == "Android" then
		local touches = love.touch.getTouches()
		for i, id in ipairs(touches) do
			local tx, ty = love.touch.getPosition(id)
			self.tx = tx/__scale
			self.ty = ty/__scale
		end
	end
end

function Touch:draw()
	love.graphics.setColor(1, 0, 0, 1)
	if self.tx and self.ty then
		love.graphics.line(self.tx, 0, self.tx, screen.y)
		love.graphics.line(0, self.ty, screen.x, self.ty)
	end

	for i, v in ipairs(self.list) do
		local obj = v[1]
		local obj2 = v[2]
		love.graphics.setColor(obj.color)
		love.graphics.circle(obj.fillType, obj.x, obj.y, obj.radius, 32)
		love.graphics.setColor(obj2.color)
		love.graphics.circle(obj2.fillType, obj2.x, obj2.y, obj2.radius, 32)
		if self.ps then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(self.ps, obj.x, obj.y)
		end
	end
end

function Touch:touchpressed(id, tx, ty, dx, dy, pressure)
	self.state = true
end

function Touch:touchreleased(id, tx, dy, dx, dy, pressure)
	self.state = false
end

function Touch:touchmoved(id, tx, dy, dx, dy, pressure)
	self.state = false
end

function Touch:getTouch() return self.state end

function Touch:simulateTouchPressed(mx, my)
	self:createObject(mx, my)
end

function Touch:simulateTouchReleased(mx, my)
end

function Touch:createObject(mx, my)
	local a = {
		color = {0, 0, 0.8, 0.3},
		x = mx, y = my, radius = 16,
		fillType = "line"
	}
	local b = {
		color = {0, 0, 0.8, 0.3},
		x = mx, y = my, radius = 8,
		fillType = "fill"
	}
	local obj = { a, b }
	local t = 0.5

	flux.to(a.color, t * 4, { [4] = 0 }):ease("backout")
	flux.to(b.color, t * 4, { [4] = 0 }):ease("backout")

	flux.to(b, t, { radius = 32 }):ease("backout")
	flux.to(a, t, { radius = 28 }):ease("backout")
		:oncomplete(function()
			for i = #self.list, 1, -1 do
				local current = self.list[i]
				if obj == current then
					table.remove(self.list, i)
					log.trace("Touch Objects Count: " .. #self.list)
					break
				end
			end
		end)
	table.insert(self.list, obj)
	log.trace("Touch Objects Count: " .. #self.list)
	if self.ps then self.ps:emit(8) end
end

return Touch
