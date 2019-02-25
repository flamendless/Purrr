local BGM = {
	current,
	data = {},
}

function BGM:start(source)
	assert(source:type() == "Source", "BGM must be a source")
	self.current = source
	self.data.duration = source:getDuration("seconds")
	self.data.pos = source:tell("seconds")
	self.data.text = ("%.2f"):format(tostring(source:getDuration("seconds")))
	source:play()
end

function BGM:update(dt)
	if self.current then
		self.data.pos = self.current:tell("seconds")
	end
end

function BGM:clear()
	self.current:stop()
	self.current = nil
	self.data.text = nil
	self.data.pos = nil
	self.data.duration = nil
end

return BGM
