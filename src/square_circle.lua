local SquareCircle = {
	state = false,
}

function SquareCircle:complete(id)
end

function SquareCircle:update(dt)
	if not self.state then return end
	self.instance:emit("update", dt)
end

function SquareCircle:draw()
	if not self.state then return end
	self.instance:emit("draw")
end

function SquareCircle:getState() return self.state end

return SquareCircle
