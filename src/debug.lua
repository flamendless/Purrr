local debugGraph = require("modules.debug-graph.debugGraph")
local lurker = require("modules.lurker.lurker")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local gamestate = require("modules.hump.gamestate")

local screen = require("src.screen")
local colors = require("src.colors")

local Debug = {
	graphs = {},
	colors = {},
	font = love.graphics.newFont(12),
}

function Debug:load()
	self.colors.line = colors(1, 0, 0, 1)
	log.trace("Load")
	log.trace("Setting Graphs")
	self.graphs.fps = debugGraph:new('fps', 0, 0)
  self.graphs.mem = debugGraph:new('mem', 0, 30)
  self.graphs.state = debugGraph:new('custom', 0, 60)
	self.graphs.fps.font = self.font
	self.graphs.mem.font = self.font
	self.graphs.state.font = self.font
end

function Debug:update(dt)
	lurker.update(dt)
	for k,v in pairs(self.graphs) do v:update(dt) end
	self.graphs.state.label = gamestate.current().__id
end

function Debug:draw()
	love.graphics.setColor(1, 0, 0, 1)
	for k,v in pairs(self.graphs) do v:draw() end

	self.colors.line:set()
	love.graphics.line(0, screen.y/2, screen.x, screen.y/2) --middle-horizontal
	love.graphics.line(screen.x/2, 0, screen.x/2, screen.y) --middle-vertical
	love.graphics.line(0, 32, screen.x, 32) --top
	love.graphics.line(0, screen.y - 32, screen.x, screen.y - 32) --bottom
	love.graphics.line(32, 0, 32, screen.y) --left
	love.graphics.line(screen.x - 32, 0, screen.x - 32, screen.y) --right
end

function Debug:keypressed(key)
	if key == "q" then
		log.trace("quit")
		love.event.quit()
	elseif key == "r" then
		log.trace("restart")
		love.event.quit("restart")
	end
end

return Debug
