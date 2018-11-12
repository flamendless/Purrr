__love = "LÖVE" --because I can't type the O with Umlaut
__debug = (love.system.getOS() == "Android") or true
__filter = "nearest"
__window = 1
__scale = 1
__version = require("modules.semver.semver")(0, 1, 3)

local debugging
local font = love.graphics.newFont(16)
if __debug then
	io.stdout:setvbuf("no")
	debugging = require("src.debug")
	love.audio.setVolume(0)
end

local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local inspect = require("modules.inspect.inspect")
local ecs = require("modules.concord.lib").init({ useEvents = false })

local assets = require("src.assets")
local data = require("src.data")
local time = require("src.time")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")
local event = require("src.event")
local touch = require("src.touch")
local soundManager = require("src.sound_manager")
local bgm = require("src.bgm")

__scale = math.min((love.graphics.getWidth()/screen.x), (love.graphics.getHeight()/screen.y))
print(("Device: %s x %s"):format(love.graphics.getDimensions()))
print(("Game: %s x %s"):format(screen.x, screen.y))
print("Scale: " .. __scale)

function love.load(args)
	if __debug then log.level = "info" end
	log.outfile = "log.log"
	log.lovesave = true
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	if __debug then debugging:init() end
	math.randomseed(os.time())
	data:init()
	event:init()
	transition:init()
	preload:init()
	gamestate:start( require("states").splash )
	-- gamestate:start( require("states").menu )
	-- gamestate:start( require("states").intro )
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
	preload:update(dt)
	bgm:update()
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
end

love.errhand = require("src.errorhandler").errhand

function love.quit()
	log.trace("Love Quit")
	data:save()
	lily.quit()
end
