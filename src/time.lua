local Time = {
	uptime = 0,
}

function Time:update(dt)
	self.uptime = self.uptime + dt
end

return Time
