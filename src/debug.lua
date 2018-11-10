local debugGraph = require("modules.debug-graph.debugGraph")
local lurker = require("modules.lurker.lurker")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local semver = require("modules.semver.semver")
local screen = require("src.screen")
local time = require("src.time")
local colors = require("src.colors")
local preload = require("src.preload")
local transition = require("src.transition")
local gamestate = require("src.gamestate")
local event = require("src.event")
local resourceManager = require("src.resource_manager")
local touch = require("src.touch")

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

local _ver = semver(1, 0, 0)

lurker.preswap = function(filename)
	return filename == "save.lua"
end

lurker.postswap = function(filename)
	log.trace("Swapped: " .. filename)
	gamestate:reload()
end

function Debug:init()
	self.colors.line = colors(1, 0, 0, 0.5)
	self.colors.graph = colors(1, 0, 0, 1)

	local x = 8
	local y = 60
	local graphs = { "state", "preload", "transition" }

	self.graphs.fps = debugGraph:new('fps', x, 0)
  self.graphs.mem = debugGraph:new('mem', x, 30)

	if __version < _ver then
  	self.graphs.beta = debugGraph:new('custom', x, screen.y - 64)
		self.graphs.beta.font = self.font
	end

	for i = 1, #graphs do
		local k = graphs[i]
		self.graphs[k] = debugGraph:new('custom', x, y + (30 * (i-1)))
	end

	for k,v in pairs(self.graphs) do
		v.font = self.font
	end
end

function Debug:update(dt)
	if not (love.system.getOS() == "Android") then lurker.update(dt) end
	for k,v in pairs(self.graphs) do v:update(dt) end
	self.graphs.state.label = ("Gamestate: %s"):format(gamestate:getCurrent().__id)
	self.graphs.preload.label = ("Preload: %s"):format(tostring(preload:getState()))
	self.graphs.transition.label = ("Transition: %s"):format(tostring(transition:getState()))
	if self.graphs.beta then
		self.graphs.beta.label = ("BETA v" .. tostring(__version))
	end
	touch:update(dt)
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
	touch:draw()
end

function Debug:keypressed(key)
	if key == "q" then
		love.event.quit()
	elseif key == "r" then
		gamestate:restartCurrent()
	elseif key == "g" then
		self.modes.graphs = not self.modes.graphs
	elseif key == "l" then
		self.modes.lines = not self.modes.lines
	elseif key == "c" then
		self.modes.collisions = not self.modes.collisions
	end
end

return Debug
