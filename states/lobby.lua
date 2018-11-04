local BaseState = require("states.base_state")
local Lobby = BaseState("Lobby")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local lume = require("modules.lume.lume")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local data = require("src.data")
local event = require("src.event")
local transition = require("src.transition")
local soundManager = require("src.sound_manager")
local assets = require("src.assets")
local pos = require("src.positions")

local window_width, window_height

function Lobby:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self:setupSystems()
	self:setupEntities()
	self:start()
end

function Lobby:setupSystems()
	self.systems = {
		collision = S.collision(),
		gui = S.gui(),
		position = S.position(),
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		cat_fsm = S.cat_fsm("lobby"),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
		follow = S.follow(),
		window_manager = S.window_manager(),
	}

	self.instance:addSystem(self.systems.renderer, "draw", "drawBG")
	self.instance:addSystem(self.systems.window_manager, "close")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.cat_fsm, "changeState")
	self.instance:addSystem(self.systems.cat_fsm, "overrideState")
	self.instance:addSystem(self.systems.cat_fsm, "changePalette")
	self.instance:addSystem(self.systems.cat_fsm, "update")
	self.instance:addSystem(self.systems.cat_fsm, "onEnter")
	self.instance:addSystem(self.systems.cat_fsm, "onExit")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.collision, "draw", "draw")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
end

function Lobby:setupEntities()
	window_width = self.images.window:getWidth() * 2
	window_height = self.images.window:getHeight() * 1.25
	self.entities = {}
	self.entities.bg = E.pattern(ecs.entity())
	self.entities.window = E.lobby_window(ecs.entity())
	self.entities.home = E.button_home(ecs.entity())
	self.entities.energy = E.button_energy(ecs.entity(), "energy", self.entities.window)
	self.entities.cat_info = E.button_cat_info(ecs.entity())
	self.entities.cat = E.cat(ecs.entity())
	self.entities.display = E.lobby_display(ecs.entity())
	self.entities.settings = E.button_settings(ecs.entity())
		:give(C.pos, pos.screen.top:clone())
		:give(C.transform, 0, 1.5, 1.5, "right")
		:give(C.maxScale, 1.75, 1.75)
		:apply()

	self.entities.play = E.lobby_button(ecs.entity(), "play", self.entities.window)
		:give(C.offsetPos, vec2(0, -window_height/2))
		:give(C.onClick, function(e) self:gotoMap() end)
		:apply()

	self.entities.bag = E.lobby_button(ecs.entity(), "bag", self.entities.window)
		:give(C.offsetPos, vec2(window_width/3.5, -window_height/2))
		:give(C.onClick, function(e) event:showBag() end)
		:apply()

	self.entities.store = E.lobby_button(ecs.entity(), "store", self.entities.window)
		:give(C.offsetPos, vec2(-window_width/3.5, -window_height/2))
		:give(C.onClick, function(e) event:showStore() end)
		:apply()

	-- self.entities.coins = ecs.entity()
	-- 	:give(C.color, colors("flat", "red", "light"))
	-- 	:give(C.pos, vec2(screen.x * 1.5, 48))
	-- 	:give(C.text, data.data.coins, self.fonts.upheaval_48, "right", screen.x - 32)
	-- 	:give(C.windowIndex, 1)
	-- 	:apply()

	self.instance:addEntity(self.entities.bg)
	self.instance:addEntity(self.entities.window)
	self.instance:addEntity(self.entities.display)
	self.instance:addEntity(self.entities.store)
	self.instance:addEntity(self.entities.play)
	self.instance:addEntity(self.entities.bag)
	self.instance:addEntity(self.entities.settings)
	self.instance:addEntity(self.entities.home)
	self.instance:addEntity(self.entities.energy)
	self.instance:addEntity(self.entities.cat_info)
	-- self.instance:addEntity(self.entities.coins)
	self.instance:addEntity(self.entities.cat)
end

function Lobby:start()
	local dur = 0.8
	flux.to(self.entities.cat_info[C.pos].pos, dur, { x = pos.lobby.cat_info:clone().x, y = pos.lobby.cat_info:clone().y }):ease("backout")
	-- flux.to(self.entities.coins[C.pos].pos, dur, { x =  0  }):ease("backout")
	flux.to(self.entities.energy[C.pos].pos, dur, { x = pos.lobby.energy:clone().x, y = pos.lobby.energy:clone().y }):ease("backout")
	flux.to(self.entities.settings[C.pos].pos, dur, { x = pos.lobby.settings:clone().x, y = pos.lobby.settings:clone().y }):ease("backout")
	flux.to(self.entities.home[C.pos].pos, dur, { x = pos.lobby.home:clone().x, y = pos.lobby.home:clone().y }):ease("backout")
	flux.to(self.entities.window[C.pos].pos, dur, { y = screen.y }):ease("backout")
	flux.to(self.entities.display[C.pos].pos, dur, { y = screen.y - window_height - 48 }):ease("backout")
	flux.to(self.entities.cat[C.pos].pos, dur, { y = pos.lobby.cat:clone().y })
		:onstart(function() self.instance:emit("changeState", "spin") end)
		:oncomplete(function()
			self.instance:emit("changeState", "blink")
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
		end)
end

function Lobby:gotoMap()
	self.instance:emit("changeState", "spin")
	self.instance:disableSystem(self.systems.collision, "update", "checkPoint")
	flux.to(self.entities.cat[C.pos].pos, 1, { y = screen.y * 1.5 }):ease("backin")
		:oncomplete(function()
			transition:start(require("states.map"))
		end)
end

function Lobby:update(dt)
	self.instance:emit("update", dt)
end

function Lobby:draw()
	self.instance:emit("draw")
end

function Lobby:buy(e, id, price)
	if data.data.coins >= price then
		soundManager:send("buy")
		data.data.coins = data.data.coins - price
		data.data.skills[id] = true
		e[C.state].isDisabled = true
		self.entities.coins[C.text].text = data.data.coins
	else
		soundManager:send("lock")
	end
end

function Lobby:addCoin(inc)
	data.data.coins = data.data.coins + inc
	self.entities.coins[C.text].text = data.data.coins
end

function Lobby:touchpressed(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchpressed", id, tx, ty, dx, dy, pressure)
end

function Lobby:touchreleased(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchreleased", id, tx, ty, dx, dy, pressure)
end

function Lobby:keypressed(key)
	if key == "escape" then
		event:showHomeConfirmation()
	end
end

function Lobby:exit()
	if self.instance then self.instance:clear() end
end

return Lobby
