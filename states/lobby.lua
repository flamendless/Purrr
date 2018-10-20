local BaseState = require("states.base_state")
local Lobby = BaseState("Lobby")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local colors = require("src.colors")
local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local data = require("src.data")
local event = require("src.event")
local transition = require("src.transition")
local assets = require("src.assets")

local bg = {}
local maxPatterns = 9

local colours = {"back","forward","yellow","green","purple","red","blue","grayscale","softmilk","black","white","lime","orange","pink"}
local palettes = {"source", "softmilk", "blue", "green", "grayscale"}
local states = {"attack","blink","dizzy","heart","hurt","mouth","sleep","snore","spin"}
local buttons = {"bag","play","store","home","settings","mute","volume","cat","star","twitter","back","accept","cancel","forward"}

function Lobby:init()
	self.assets = {
		images = {
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
			{ id = "energy_full", path = "assets/gui/energy_full.png" },
			{ id = "energy_half", path = "assets/gui/energy_half.png" },
			{ id = "energy_empty", path = "assets/gui/energy_empty.png" },
			{ id = "window", path = "assets/gui/window.png" },
			{ id = "display_lobby", path = "assets/images/display_lobby.png" },
			{ id = "name", path = "assets/gui/name.png" },
		},
		sources = {
			{ id = "sfx_transition", path = "assets/sounds/cat/deep_meow.ogg", kind = "stream" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
			{ id = "buttons", path = "assets/fonts/futurehandwritten.ttf", sizes = { 24, 30, 32, 36, 42, 48 } },
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42, 48} },
		}
	}
	for _, btn in ipairs(buttons) do
		local id = "button_" .. btn
		local id_hovered = "button_" .. btn .. "_hovered"
		local path = "assets/gui/" .. id .. ".png"
		local path_hovered = "assets/gui/" .. id_hovered .. ".png"
		table.insert(self.assets.images, { id = id, path = path })
		table.insert(self.assets.images, { id = id_hovered, path = path_hovered })
	end
	for i, state in ipairs(states) do
		local id = "sheet_cat_" .. state
		local path = "assets/anim/cat_" .. state .. ".png"
		table.insert(self.assets.images, { id = id, path = path })
	end

	for _, palette in ipairs(palettes) do
		for _, state in ipairs(states) do
			local id = ("pal_%s_%s"):format(state, palette)
			local path = ("assets/palettes/%s/%s.png"):format(palette, state)
			table.insert(self.assets.images, { id = id, path = path })
		end
	end

	for _,btn in ipairs(colours) do
		local id = "btn_" .. btn
		local id_hovered = id .. "_hovered"
		local path = "assets/gui/button_" .. btn .. ".png"
		local path_hovered = "assets/gui/button_" .. btn .. "_hovered.png"
		table.insert(self.assets.images, { id = id, path = path })
		table.insert(self.assets.images, { id = id_hovered, path = path_hovered })
	end
	for i = 1, maxPatterns do
		local id = "pattern" .. i
		local path = "assets/images/pattern" .. i .. ".png"
		table.insert(self.assets.images, { id = id, path = path })
	end
end

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
	}

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
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.collision, "draw", "draw")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.position, "update")
end

function Lobby:setupEntities()
	self.entities = {}
	self.entities.window = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.sprite, self.images.window)
		:give(C.pos, vec2(screen.x/2, screen.y * 2))
		:give(C.transform, 0, 2, 1.25, "center", "bottom")
		:apply()

	local window_width = self.images.window:getWidth() * 2
	local window_height = self.images.window:getHeight() * 1.25
	self.entities.store = E.lobby_buttons(ecs.entity(), "store", "store")
		:give(C.follow, self.entities.window)
		:give(C.offsetPos, vec2(-window_width/3.5, -window_height/2))
		:give(C.onClick, function(e)
				event:showStore()
			end)
		:apply()

	self.entities.play = E.lobby_buttons(ecs.entity(), "play", "play")
		:give(C.follow, self.entities.window)
		:give(C.offsetPos, vec2(0, -window_height/2))
		:give(C.onClick, function(e)
				self:gotoMap()
			end)
		:apply()

	self.entities.bag = E.lobby_buttons(ecs.entity(), "bag", "bag")
		:give(C.follow, self.entities.window)
		:give(C.offsetPos, vec2(window_width/3.5, -window_height/2))
		:apply()

	self.entities.settings = E.lobby_buttons(ecs.entity(), "settings", "settings")
		:remove(C.pos):remove(C.transform):apply()
		:give(C.pos, vec2(screen.x * 2 - 32, 32 + self.images.name:getHeight() * 2 + 8))
		:give(C.transform, 0, 2, 2, "right")
		:give(C.onClick, function(e) event:showSettings() end)
		:apply()

	self.entities.home = E.lobby_buttons(ecs.entity(), "home", "home")
		:remove(C.pos):remove(C.transform):apply()
		:give(C.pos, vec2(screen.x * 2 - 128, 32 + self.images.name:getHeight() * 2 + 8))
		:give(C.transform, 0, 2, 2, "right")
		:give(C.onClick, function(e) event:showHomeConfirmation() end)
		:apply()

	self.entities.cat_info = E.lobby_buttons(ecs.entity(),"cat", "cat")
		:remove(C.pos):remove(C.transform):apply()
		:give(C.pos, vec2(-screen.x/2, 16))
		:give(C.transform, 0, 2, 2)
		:give(C.onClick, function(e) event:showCatInfo() end)
		:apply()

	self.entities.energy = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.button, "energy", {
				normal = self.images["energy_" .. data.data.energy],
				hovered = self.images["energy_" .. data.data.energy]
			})
		:give(C.pos, vec2(-screen.x/2, 32 + self.images.name:getHeight() * 2 + 8))
		:give(C.transform, 0, 2, 2)
		:give(C.maxScale, 2.75, 2.75)
		:give(C.windowIndex, 1)
		:give(C.onClick, function(e) event:showEnergyInfo() end)
		:apply()

	self.entities.cat = ecs.entity()
		:give(C.tag, "cat")
		:give(C.cat)
		:give(C.fsm, "blink", { "attack", "blink", "dizzy", "hurt", "heart", "mouth", "sleep", "snore", "spin"})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.transform, 0, 4, 4, "center", "center")
		:apply()

	self.entities.display = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(-screen.x/2, screen.y - window_height - 48))
		:give(C.sprite, self.images.display_lobby)
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	self.instance:addEntity(self.entities.window)
	self.instance:addEntity(self.entities.display)
	self.instance:addEntity(self.entities.store)
	self.instance:addEntity(self.entities.play)
	self.instance:addEntity(self.entities.bag)
	self.instance:addEntity(self.entities.settings)
	self.instance:addEntity(self.entities.home)
	self.instance:addEntity(self.entities.energy)
	self.instance:addEntity(self.entities.cat_info)
	self.instance:addEntity(self.entities.cat)
end

function Lobby:start()
	local r = math.random(1, maxPatterns)
	bg.image = self.images["pattern" .. r]
	bg.sx = screen.x/bg.image:getWidth()
	bg.sy = screen.y/bg.image:getHeight()
	local dur = 0.8
	flux.to(self.entities.cat_info[C.pos].pos, dur, { x = 8 }):ease("backout")
	flux.to(self.entities.energy[C.pos].pos, dur, { x = 8 }):ease("backout")
	flux.to(self.entities.settings[C.pos].pos, dur, { x = screen.x - 8 }):ease("backout")
	flux.to(self.entities.home[C.pos].pos, dur, { x = screen.x - 104 }):ease("backout")
	flux.to(self.entities.window[C.pos].pos, dur, { y = screen.y }):ease("backout")
	flux.to(self.entities.display[C.pos].pos, dur, { x = screen.x/2 }):ease("backout")
	flux.to(self.entities.cat[C.pos].pos, dur * 2, { y = screen.y  * 0.5 }):ease("backout")
		:oncomplete(function()
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
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(bg.image, 0, 0, 0, bg.sx, bg.sy)
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Lobby:touchpressed(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchpressed", id, tx, ty, dx, dy, pressure)
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
