local Gamestate = {
	__current,
	__previous,
	__preloading,
	__args = {},
}

local log = require("modules.log.log")
local preload = require("src.preload")
local assets = require("src.assets")
local soundManager = require("src.sound_manager")
local bgm = require("src.bgm")

function Gamestate:enablePreloading()
	self.__preloading = require("ecs.instances.loading")
	self.__preloading:load()
end

function Gamestate:disablePreloading()
	if self.__preloading and self.__preloading.exit then
		self.__preloading:exit()
	end
	self.__preloading = nil
end

function Gamestate:restartCurrent()
	self:preload()
end

function Gamestate:start(state)
	assert(state, "State must be passed")
	self.__current = state
	self:preload()
end

function Gamestate:switch(state, ...)
	self:exit()
	self.__previous = self.__current
	self.__current = state
	self.__args = { ... }
	self:preload()
end

function Gamestate:reload()
	self:switch(self.__current)
end

function Gamestate:preload()
	log.trace("Preload started!")
	local a = assets:load(self.__current.__id)
	if a then
		preload:check(a)
		self.isPreloading = true
	end
end

function Gamestate:enter(previous, ...)
	log.trace(("State %s Entered!"):format(self.__current.__id))
	bgm:set(self.__current, previous)
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
	if self.__preloading then self.__preloading:update(dt) end
end

function Gamestate:draw()
	if self.__current.draw and self.__current.isReady then
		self.__current:draw()
	end
	if self.__preloading then self.__preloading:draw() end
end

function Gamestate:keypressed(key)
	if self.__current.keypressed and self.__current.isReady then
		self.__current:keypressed(key)
	end
end

function Gamestate:keyreleased(key)
	if self.__current.keyreleased and self.__current.isReady then
		self.__current:keyreleased(key)
	end
end

function Gamestate:mousepressed(mx, my, mb, istouch, count)
	if self.__current.mousepressed and self.__current.isReady then
		self.__current:mousepressed(mx, my, mb, istouch, count)
	end
end

function Gamestate:mousereleased(mx, my, mb, istouch, count)
	if self.__current.mousereleased and self.__current.isReady then
		self.__current:mousereleased(mx, my, mb, istouch, count)
	end
end

function Gamestate:touchpressed(id, tx, ty, dx, dy, pressure)
	if self.__current.touchpressed and self.__current.isReady then
		self.__current:touchpressed(id, tx, ty, dx, dy, pressure)
	end
end

function Gamestate:touchreleased(id, tx, ty, dx, dy, pressure)
	if self.__current.touchreleased and self.__current.isReady then
		self.__current:touchreleased(id, tx, ty, dx, dy, pressure)
	end
end

function Gamestate:touchmoved(id, tx, ty, dx, dy, pressure)
	if self.__current.touchmoved and self.__current.isReady then
		self.__current:touchmoved(id, tx, ty, dx, dy, pressure)
	end
end

function Gamestate:textinput(t)
	if self.__current.textinput and self.__current.isReady then
		self.__current:textinput(t)
	end
end

function Gamestate:exit()
	if self.__current and self.__current.exit then
		self.__current:exit()
	end
	bgm:reset()
end

function Gamestate:getCurrent() return self.__current end

return Gamestate
