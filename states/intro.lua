local BaseState = require("states.base_state")
local Intro = BaseState("Intro")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local resourceManager = require("src.resource_manager")

function Intro:init()
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
		}
	}
	self.colors = {}
end

function Intro:enter(previous, ...)
	self.images = resourceManager:getAll("images")
end

function Intro:update(dt)

end

function Intro:draw()

end

function Intro:exit()

end

return Intro
