local class = require("modules.classic.classic")
local BaseState = class:extend()

function BaseState:new(id)
	self.__id = id or "?state"
	self.__isReady = false
end

return BaseState
