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
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local data = require("src.data")

local bg = {}
local maxPatterns = 9

function Lobby:init()
	self.assets = {
		images = {}
	}
	self.colors = {}

	for i = 1, maxPatterns do
		local id = "pattern" .. i
		local path = "assets/images/pattern" .. i .. ".png"
		table.insert(self.assets.images, { id = id, path = path })
	end
end

function Lobby:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self:start()
end

function Lobby:start()
	local r = math.random(1, maxPatterns)
	bg.image = self.images["pattern" .. r]
	bg.sx = screen.x/bg.image:getWidth()
	bg.sy = screen.y/bg.image:getHeight()
end

function Lobby:update(dt)
end

function Lobby:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(bg.image, 0, 0, 0, bg.sx, bg.sy)
end

function Lobby:exit()
end

return Lobby
