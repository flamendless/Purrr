local Gamestate = {
	__current,
	__previous,
	__preloading,
	__args = {},
	__instances = {},
}

local log = require("modules.log.log")
local preload = require("src.preload")

function Gamestate:addInstance(id, instance, ...)
	instance.id = id
	instance:load(...)
	self.__instances[id] = instance
end

function Gamestate:removeInstance(id)
	if self.__instances[id] and self.__instances[id].exit then
		self.__instances[id]:exit()
	end
	self.__instances[id] = nil
end

function Gamestate:start(state)
	self.__current = state
	self:init()
end

function Gamestate:switch(state, ...)
	self.__previous = self.__current
	self.__current = state
	self.__args = { ... }
	self:init()
end

function Gamestate:init()
	if self.__current and self.__current.init then
		self.__current:init()
		if self.__current.assets then
			log.trace("Preload started!")
			preload:check(self.__current.assets)
			self.isPreloading = true
		end
	end
end

function Gamestate:enter(previous, ...)
	log.trace(("State %s Entered!"):format(self.__current.__id))
	self.__current:enter(previous, ...)
	self.__current.isReady = true
end

function Gamestate:update(dt)
	if self.isPreloading then
		if not preload.isActive then
			self:enter(self.__previous, unpack(self.__args))
			self.isPreloading = false
		end
	end
	if self.__current.update and self.__current.isReady then
		self.__current:update(dt)
	end
	for k,v in pairs(self.__instances) do
		if v.update then
			v:update(dt)
		end
	end
end

function Gamestate:draw()
	if self.__current.draw and self.__current.isReady then
		self.__current:draw()
	end
	for k,v in pairs(self.__instances) do
		if v.draw then
			v:draw()
		end
	end
end

function Gamestate:keypressed(key)
	if self.__current.keypressed and self.__current.isReady then
		self.__current:keypressed(key)
	end
	for k,v in pairs(self.__instances) do
		if v.keypressed then
			v:keypressed(key)
		end
	end
end

function Gamestate:keyreleased(key)
	if self.__current.keyreleased and self.__current.isReady then
		self.__current:keyreleased(key)
	end
	for k,v in pairs(self.__instances) do
		if v.keyreleased then
			v:keyreleased(key)
		end
	end
end

function Gamestate:mousepressed(mx, my, mb)
	if self.__current.mousepressed and self.__current.isReady then
		self.__current:mousepressed(mx, my, mb)
	end
	for k,v in pairs(self.__instances) do
		if v.mousepressed then
			v:mousepressed(mx, my, mb)
		end
	end
end

function Gamestate:mousereleased(mx, my, mb)
	if self.__current.mousereleased and self.__current.isReady then
		self.__current:mousereleased(mx, my, mb)
	end
	for k,v in pairs(self.__instances) do
		if v.mousereleased then
			v:mousereleased(mx, my, mb)
		end
	end
end

function Gamestate:getCurrent() return self.__current end

return Gamestate
