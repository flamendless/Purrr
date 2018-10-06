local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}

local S = require("ecs.systems")
local C = require("ecs.components")

local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

local Touch = {}

function Touch:load()

end

function Touch:update(dt)
end

function Touch:draw()
end

return Touch
