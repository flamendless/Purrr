__love = "LÖVE" --because I can't type the O with Umlaut
__debug = true
__filter = "nearest"
__window = 1

local debugging
if __debug then
	io.stdout:setvbuf("no")
	debugging = require("src.debug")
end

local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local coil = require("modules.coil.coil")
local ecs = require("modules.concord.lib").init({ useEvents = false })

local time = require("src.time")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")
local event = require("src.event")

function love.load()
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug then debugging:load() end
	math.randomseed(os.time())
	event:init()
	transition:init()
	preload:init()
	-- gamestate:start( require("states").splash )
	gamestate:start( require("states").menu )
end

function love.update(dt)
	if __debug then debugging:update(dt) end
	timer.update(dt)
	coil.update(dt)
	flux.update(dt)
	time:update(dt)
	preload:update(dt)
	gamestate:update(dt)
end

function love.draw()
	preload:draw()
	gamestate:draw()
	transition:draw()
	if __debug then debugging:draw() end
end

function love.keypressed(key)
	gamestate:keypressed(key)
	if __debug then debugging:keypressed(key) end
end

function love.mousepressed(mx, my, mb)
	gamestate:mousepressed(mx, my, mb)
end

function love.quit()
	log.trace("Love Quit")
	lily.quit()
end
