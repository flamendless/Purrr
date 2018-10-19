__love = "LÖVE" --because I can't type the O with Umlaut
__debug = true
__filter = "nearest"
__window = 1
__scale = 1

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

local data = require("src.data")
local time = require("src.time")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")
local event = require("src.event")
local touch = require("src.touch")

__scale = math.min((love.graphics.getWidth()/screen.x), (love.graphics.getHeight()/screen.y))
print(("Device: %s x %s"):format(love.graphics.getDimensions()))
print(("Game: %s x %s"):format(screen.x, screen.y))
print("Scale: " .. __scale)

function love.load()
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug then debugging:init() end
	math.randomseed(os.time())
	data:init()
	event:init()
	transition:init()
	preload:init()
	-- gamestate:start( require("states").splash )
	-- gamestate:start( require("states").menu )
	-- gamestate:start( require("states").intro )
	-- gamestate:start( require("states").customization )
	gamestate:start( require("states").lobby )
end

function love.update(dt)
	if __debug then debugging:update(dt) end
	timer.update(dt)
	coil.update(dt)
	flux.update(dt)
	time:update(dt)
	touch:update(dt)
	preload:update(dt)
	gamestate:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(__scale, __scale)
	preload:draw()
	gamestate:draw()
	transition:draw()
	if __debug then debugging:draw() end
	love.graphics.pop()
end

function love.keypressed(key)
	gamestate:keypressed(key)
	if __debug and debugging.keypressed then debugging:keypressed(key) end
end

function love.keyreleased(key)
	gamestate:keyreleased(key)
	if __debug and debugging.keyreleased then debugging:keyreleased(key) end
end

function love.mousepressed(mx, my, mb, istouch, count)
	gamestate:mousepressed(mx, my, mb, istouch, count)
end

function love.mousereleased(mx, my, mb, istouch, count)
	gamestate:mousereleased(mx, my, mb, istouch, count)
end

function love.touchpressed(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	gamestate:touchpressed(id, tx, ty, dx, dy, pressure)
	touch:touchpressed(id, tx, ty, dx, dy, pressure)
end

function love.touchreleased(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	gamestate:touchreleased(id, tx, ty, dx, dy, pressure)
	touch:touchreleased(id, tx, ty, dx, dy, pressure)
end

function love.touchmoved(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	gamestate:touchmoved(id, tx, ty, dx, dy, pressure)
	touch:touchmoved(id, tx, ty, dx, dy, pressure)
end

function love.textinput(t)
	gamestate:textinput(t)
end

love.errhand = require("src.errorhandler").errhand

function love.quit()
	log.trace("Love Quit")
	lily.quit()
end
