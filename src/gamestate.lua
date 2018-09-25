local Gamestate = {
	__current,
	__previous,
	__preloading,
	__args = {},
}

local log = require("modules.log.log")
local preload = require("src.preload")

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
	if self.__current.init then
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
end

function Gamestate:draw()
	if self.__current.draw and self.__current.isReady then
		self.__current:draw()
	end
end

function Gamestate:keypressed(key)
	if self.__current.keypressed and self.__current.isReady then
		self.__current:keypressed(key)
	end
end

function Gamestate:mousepressed(mx, my, mb)
	if self.__current.mousepressed and self.__current.isReady then
		self.__current:mousepressed(mx, my, mb)
	end
end

function Gamestate:getCurrent() return self.__current end

return Gamestate
