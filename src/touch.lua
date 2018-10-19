local Touch = { state = false }

local screen = require("src.screen")

function Touch:update(dt)
	if not (love.system.getOS() == "Android") then return end
	local touches = love.touch.getTouches()
	for i, id in ipairs(touches) do
		local tx, ty = love.touch.getPosition(id)
		self.tx = tx/__scale
		self.ty = ty/__scale
	end
end

function Touch:draw()
	love.graphics.setColor(1, 0, 0, 1)
	if self.tx and self.ty then
		love.graphics.line(self.tx, 0, self.tx, screen.y)
		love.graphics.line(0, self.ty, screen.x, self.ty)
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

return Touch
