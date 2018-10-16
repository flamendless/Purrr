local AnimationData = {}

function AnimationData:init()
	self.data = {
		c_attack = { speed = 0.25 },
		c_blink = { speed = 0.25 },
		c_dizzy = { speed = 0.25 },
		c_heart = { speed = 0.25 },
		c_hurt = { speed = 0.25 },
		c_mouth = { speed = 0.25 },
		c_sleep = { speed = 0.25 },
		c_snore = { speed = 0.25 },
		c_spin = { speed = 0.25 },
	}
end

function AnimationData:getSpeed(tag)
	return self.data["c_" .. tag].speed
end

return AnimationData
