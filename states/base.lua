local BaseState = require("states.base_state")
local Base = BaseState("Base")

local transition = require("src.transition")
local resourceManager = require("src.resource_manager")

function Base:enter(previous, ...)
	if __debug then
		transition:start(require("states")[__next_state])
	else
		transition:start(require("states").splash)
	end
end

return Base
