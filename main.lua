__love = "LÖVE" --because I can't type the O with Umlaut
__debug = true
__filter = "nearest" --or nearest

local debugging
if __debug then
	io.stdout:setvbuf("no")
	debugging = require("src.debug")
end

local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local gamestate = require("modules.hump.gamestate")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local scrale = require("modules.scrale.scrale")
local ecs = require("modules.concord.lib").init({ useEvents = false })

local screen = require("src.screen")
local preload = require("src.preload")

function love.load()
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug then debugging:load() end
	scrale.init({
			fillHorizontally = false, fillVertically = false,
			scaleFilter = __filter, scaleAnisotropy = 1,
			blendMode = { "alpha", "premultiplied" }
		})
	preload:init()
	gamestate.switch( require("states").splash )
end

function love.update(dt)
	if __debug then debugging:update(dt) end
	timer.update(dt)
	flux.update(dt)
	preload:update(dt)
	if preload:getState() then return end
	if gamestate.current() then gamestate.current():update(dt) end
end

function love.draw()
	if __debug then debugging:draw() end
	preload:draw()
	if preload:getState() then return end
	if gamestate.current() then gamestate.current():draw() end
end

function love.quit()
	log.trace("Love Quit")
	lily.quit()
end
