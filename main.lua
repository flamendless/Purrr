--GLOBAL VARIABLES
__love = "LÖVE" --because I can't type the O with Umlaut
__filter = "nearest"
__scale = 1

__desktop_width, __desktop_height = love.window.getDesktopDimensions()

__version = require("modules.semver.semver")(0, 1, 4)

--MODULES
local log

log = require("modules.log.log")
log.outfile = "log.log"
log.level = "trace"
log.lovesave = true

local lily = require("modules.lily.lily")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local ecs = require("modules.concord.lib").init({ useEvents = false })

--DEBUGGING and LOGGING
local debugging

require("imgui")
io.stdout:setvbuf("no")
debugging = require("src.debug")


--SOURCE FILES
local assets = require("src.assets")
local config = require("src.config")
local time = require("src.time")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local preload = require("src.preload")
local transition = require("src.transition")
local touch = require("src.touch")
local bgm = require("src.bgm")
local states = require("states")

--INITIALIZATION
__scale = math.min((love.graphics.getWidth()/screen.x), (love.graphics.getHeight()/screen.y))

log.info(("Device: %s x %s"):format(love.graphics.getDimensions()))
log.info(("Game: %s x %s"):format(screen.x, screen.y))
log.info("Scale: " .. __scale)


function love.load(args)
	
	log.trace("Love Load")
	log.trace(("Screen Size: %ix%i"):format(screen.x, screen.y))
	
	
	love.window.setMode(__desktop_width - 64, love.graphics.getHeight())
	debugging:init()
	
	math.randomseed(os.time())
	touch:init()
	config:init()
	transition:init()
	preload:init()

	--TODO: uncomment when releasing
	-- local init_state = states.splash

	local init_state = states.menu
	gamestate:start(init_state)
end

function love.update(dt)
	
	debugging:update(dt)
	
	timer.update(dt)
	flux.update(dt)
	time:update(dt)
	touch:update(dt)
	bgm:update(dt)
	gamestate:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(__scale, __scale)
	preload:draw()
	gamestate:draw()
	transition:draw()
	touch:draw()
	
	debugging:draw()
	
	love.graphics.pop()
end

function love.keypressed(key)
	gamestate:keypressed(key)
	
	debugging:keypressed(key)
	
end

function love.keyreleased(key)
	gamestate:keyreleased(key)
	
	debugging:keyreleased(key)
	
end

function love.mousepressed(mx, my, mb, istouch, count)
	gamestate:mousepressed(mx, my, mb, istouch, count)
	touch:simulateTouchPressed(mx, my)
	
	debugging:mousepressed(mx, my, mb, istouch, count)
	
end

function love.mousereleased(mx, my, mb, istouch, count)
	gamestate:mousereleased(mx, my, mb, istouch, count)
	touch:simulateTouchReleased(mx, my)
	
	debugging:mousereleased(mx, my, mb, istouch, count)
	
end

function love.wheelmoved(wx, wy)
	
	debugging:wheelmoved(wx, wy)
	
end

function love.mousemoved(mx, my)
	
	debugging:mousemoved(mx, my)
	
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
	
	debugging:textinput(t)
	
end

love.errhand = require("src.errorhandler").errhand

function love.quit()
	
	log.trace("Love Quit")
	
	config:save()
	lily.quit()
	
	debugging:quit()
	
end
