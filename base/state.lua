local class = require("modules.classic.classic")
local BaseState = class:extend()
local screen = require("src.screen")

function BaseState:new(id)
	self.__id = id or "?state"
	self.__isReady = false
end

function BaseState:getID()
	return self.__id
end

function BaseState:setBackground(img)
	assert(img:type() == "Image", "arg1 must be an image")
	self.__bg = img
end

function BaseState:drawBackground()
	love.graphics.draw(self.__bg, 0, 0, 0, screen.x/self.__bg:getWidth(), screen.y/self.__bg:getHeight())
end

return BaseState
