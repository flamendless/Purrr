local BGM = {
	current = 1,
	queue = {},
}

local resourceManager = require("src.resource_manager")
local data = require("src.data")

function BGM:set(current, previous)
	local current_id = string.lower(current.__id)
	local previous_id = previous and string.lower(previous.__id)
	if current_id == "menu" then
		self:add(resourceManager:getSource("bgm_menu"))
	elseif current_id == "intro" then
		self:add(resourceManager:getSource("bgm_intro"))
	elseif current_id == "customization" then
		self:add(resourceManager:getSource("bgm_customization"))
	elseif current_id == "lobby" then
		local t = { resourceManager:getSource("bgm_lobby1"), resourceManager:getSource("bgm_lobby2") }
		self:add(t[1])
		self:add(t[2])
	elseif current_id == "map" then
		local t = { resourceManager:getSource("bgm_map1"), resourceManager:getSource("bgm_map2") }
		self:add(t[1])
		self:add(t[2])
	end
	self:setLooping()
end

function BGM:add(bgm)
	table.insert(self.queue, bgm)
end

function BGM:play()
	self.queue[self.current]:play()
end

function BGM:setLooping()
	if #self.queue > 1 then
		for i,bgm in ipairs(self.queue) do
			bgm:setLooping(false)
		end
	else
		if self.queue[self.current] then
			self.queue[self.current]:setLooping(true)
		end
	end
end

function BGM:update(dt)
	if self.queue[self.current] then
		if not (self.queue[self.current]:isPlaying()) then
			self.current = self.current + 1
			if self.current > #self.queue then
				self.current = 1
			end
			self:play()
		end
	end
end

function BGM:reset()
	if self.queue[self.current] then
		for i,bgm in ipairs(self.queue) do
			self.queue[i]:stop()
			self.queue[i] = nil
		end
	end
end

function BGM:skip()
	if self.queue[self.current] then
		self.queue[self.current]:seek(self.queue[self.current]:getDuration() - 3)
	end
end

return BGM
