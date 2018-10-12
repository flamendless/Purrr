local BaseState = require("states.base_state")
local Lobby = BaseState("Lobby")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local colors = require("src.colors")

function Lobby:init()
	self.assets = {}
	self.colors = {}
end

function Lobby:enter(previous, ...)
end

function Lobby:update(dt)
end

function Lobby:draw()
end

function Lobby:exit()
end

return Lobby
