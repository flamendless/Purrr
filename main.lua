__love = "LÖVE" --because I can't type the O with Umlaut
__debug = true
__filter = "nearest"
__window = 1
__scale = 1
__version = require("modules.semver.semver")(0, 1, 4)
__isDesktop = love.system.getOS() == "Windows" or love.system.getOS() == "Linux"
__isMobile = love.system.getOS() == "Android"

local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local inspect = require("modules.inspect.inspect")
local ecs = require("modules.concord.lib").init({ useEvents = false })
local font = love.graphics.newFont(16)

local debugging
log.outfile = "log.log"
log.level = "trace"
log.lovesave = true
if __debug then
	require("imgui")
	io.stdout:setvbuf("no")
	debugging = require("src.debug")
	__inspect = require("modules.inspect.inspect")
	__flags_tree = {}
end

local assets = require("src.assets")
local data = require("src.data")
local time = require("src.time")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")
local touch = require("src.touch")

__scale = math.min((love.graphics.getWidth()/screen.x), (love.graphics.getHeight()/screen.y))
log.info(("Device: %s x %s"):format(love.graphics.getDimensions()))
log.info(("Game: %s x %s"):format(screen.x, screen.y))
log.info("Scale: " .. __scale)

function love.load(args)
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug and __isDesktop then
		love.window.setMode(960, love.graphics.getHeight())
		love.window.setPosition(1280 - love.graphics.getWidth(), 0)
		debugging:init()
	end
	math.randomseed(os.time())
	touch:init()
	data:init()
	transition:init()
	preload:init()

	__next_state = "menu"
	gamestate:start( require("states").base )
	-- gamestate:start( require("states").splash )
	-- gamestate:start( require("states").intro )
	-- gamestate:start( require("states").menu )
	-- gamestate:start( require("states").customization )
	-- gamestate:start( require("states").lobby )
	-- gamestate:start( require("states").map )
end

function love.update(dt)
	if __debug then debugging:update(dt) end
	timer.update(dt)
	flux.update(dt)
	time:update(dt)
	touch:update(dt)
	gamestate:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(__scale, __scale)
	preload:draw()
	gamestate:draw()
	transition:draw()
	touch:draw()
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
	touch:simulateTouchPressed(mx, my)
	if __debug and debugging.mousepressed then debugging:mousepressed(mx, my, mb, istouch, count) end
end

function love.mousereleased(mx, my, mb, istouch, count)
	gamestate:mousereleased(mx, my, mb, istouch, count)
	touch:simulateTouchReleased(mx, my)
	if __debug and debugging.mousereleased then debugging:mousereleased(mx, my, mb, istouch, count) end
end

function love.wheelmoved(wx, wy)
	if __debug and debugging.wheelmoved then debugging:wheelmoved(wx, wy) end
end

function love.mousemoved(mx, my)
	if __debug and debugging.mousemoved then debugging:mousemoved(mx, my) end
end

function love.touchpressed(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	touch:touchpressed(id, tx, ty, dx, dy, pressure)
	gamestate:touchpressed(id, tx, ty, dx, dy, pressure)
end

function love.touchreleased(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	touch:touchreleased(id, tx, ty, dx, dy, pressure)
	gamestate:touchreleased(id, tx, ty, dx, dy, pressure)
end

function love.touchmoved(id, tx, ty, dx, dy, pressure)
	local tx = tx/__scale
	local ty = ty/__scale
	touch:touchmoved(id, tx, ty, dx, dy, pressure)
	gamestate:touchmoved(id, tx, ty, dx, dy, pressure)
end

function love.textinput(t)
	gamestate:textinput(t)
	if __debug and debugging.textinput then debugging:textinput(t) end
end

love.errhand = require("src.errorhandler").errhand

function love.quit()
	log.trace("Love Quit")
	data:save()
	lily.quit()
	if __debug and debugging.quit then debugging:quit() end
end
