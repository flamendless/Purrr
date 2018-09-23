__love = "LÖVE" --because I can't type the O with Umlaut
__debug = true
__filter = "nearest"

local debugging
if __debug then
	io.stdout:setvbuf("no")
	debugging = require("src.debug")
end

local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local ecs = require("modules.concord.lib").init({ useEvents = false })

local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")

function love.load()
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug then debugging:load() end
	transition:init()
	preload:init()
	gamestate:start( require("states").splash )
end

function love.update(dt)
	if __debug then debugging:update(dt) end
	timer.update(dt)
	flux.update(dt)
	preload:update(dt)
	if preload:getState() then return end
	gamestate:update(dt)
end

function love.draw()
	preload:draw()
	if preload:getState() then return end
	gamestate:draw()
	transition:draw()
	if __debug then debugging:draw() end
end

function love.keypressed(key)
	gamestate:keypressed(key)
	if __debug then debugging:keypressed(key) end
end

function love.quit()
	log.trace("Love Quit")
	lily.quit()
end
