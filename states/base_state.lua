local class = require("modules.classic.classic")
local BaseState = class:extend()

function BaseState:new(id)
	self.__id = id or "?state"
	self.__isReady = false
end

function BaseState:getID()
	return self.__id
end

return BaseState
