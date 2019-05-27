local BGM = {
	current,
	data = {},
}

function BGM:start(source, title)
	assert(source:type() == "Source", "BGM must be a source")
	self.current = source
	if title then
		self.data.title = "BGM " .. title
	else
		self.data.title = "?BGM"
	end
	self.data.duration = source:getDuration("seconds")
	self.data.pos = source:tell("seconds")
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