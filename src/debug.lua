local debugGraph = require("modules.debug-graph.debugGraph")
local lurker = require("modules.lurker.lurker")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")

local screen = require("src.screen")
local time = require("src.time")
local colors = require("src.colors")
local preload = require("src.preload")
local transition = require("src.transition")
local gamestate = require("src.gamestate")
local event = require("src.event")
local resourceManager = require("src.resource_manager")

local Debug = {
	graphs = {},
	colors = {},
	font = love.graphics.newFont(12),
	modes = {
		graphs = true,
		lines = true,
		collisions = true,
	},
}

lurker.postswap = function(filename)
	log.trace("Swapped: " .. filename)
	gamestate:reload()
end

function Debug:init()
	self.colors.line = colors(1, 0, 0, 0.5)
	self.colors.graph = colors(1, 0, 0, 1)
	log.trace("Load")
	log.trace("Setting Graphs")
	self.graphs.fps = debugGraph:new('fps', 0, 0)
  self.graphs.mem = debugGraph:new('mem', 0, 30)
  self.graphs.uptime = debugGraph:new('custom', 64, 0)
  self.graphs.state = debugGraph:new('custom', 0, 60)
  self.graphs.preload = debugGraph:new('custom', 0, 90)
  self.graphs.transition = debugGraph:new('custom', 0, 120)
	self.graphs.fps.font = self.font
	self.graphs.mem.font = self.font
	self.graphs.uptime.font = self.font
	self.graphs.state.font = self.font
	self.graphs.preload.font = self.font
	self.graphs.transition.font = self.font
end

function Debug:update(dt)
	lurker.update(dt)
	for k,v in pairs(self.graphs) do v:update(dt) end
	self.graphs.uptime.label = ("Uptime: %i"):format(time.uptime)
	self.graphs.state.label = ("Gamestate: %s"):format(gamestate:getCurrent().__id)
	self.graphs.preload.label = ("Preload: %s"):format(tostring(preload:getState()))
	self.graphs.transition.label = ("Transition: %s"):format(tostring(transition:getState()))
end

function Debug:draw()
	if self.modes.graphs then
		self.colors.graph:set()
		for k,v in pairs(self.graphs) do v:draw() end
	end

	if self.modes.lines then
		self.colors.line:set()
		love.graphics.line(0, screen.y/2, screen.x, screen.y/2) --middle-horizontal
		love.graphics.line(screen.x/2, 0, screen.x/2, screen.y) --middle-vertical
		love.graphics.line(0, 32, screen.x, 32) --top
		love.graphics.line(0, screen.y - 32, screen.x, screen.y - 32) --bottom
		love.graphics.line(32, 0, 32, screen.y) --left
		love.graphics.line(screen.x - 32, 0, screen.x - 32, screen.y) --right
	end
end

function Debug:keypressed(key)
	if key == "q" then
		love.event.quit()
	elseif key == "r" then
		love.event.quit("restart")
	elseif key == "g" then
		self.modes.graphs = not self.modes.graphs
	elseif key == "l" then
		self.modes.lines = not self.modes.lines
	elseif key == "c" then
		self.modes.collisions = not self.modes.collisions
	elseif key == "h" then
		event:showHomeConfirmation()
	elseif key == "p" then
		print(inspect(resourceManager:getRef()))
	end
end

return Debug
