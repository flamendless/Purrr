local BaseState = require("states.base_state")
local Customization = BaseState("Customization")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")

local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local event = require("src.event")

local next_state
local bg = {}
local quad
local maxPatterns = 9

function Customization:init()
	local states = {"attack","blink","dizzy","heart","hurt","mouth","sleep","snore","spin"}
	local palettes = {"source", "softmilk", "blue", "green", "grayscale"}
	local button = {"back","forward","yellow","green","purple","red","blue","grayscale","softmilk","black","white","lime","orange","pink"}
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "header", path = "assets/gui/header.png" },
			{ id = "window", path = "assets/gui/window.png" },
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
			{ id = "btn_accept", path = "assets/gui/accept.png" },
			{ id = "btn_accept_hovered", path = "assets/gui/accept_hovered.png" },
			{ id = "btn_cancel", path = "assets/gui/cancel.png" },
			{ id = "btn_cancel_hovered", path = "assets/gui/cancel_hovered.png" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
			{ id = "buttons", path = "assets/fonts/futurehandwritten.ttf", sizes = { 24, 30, 32, 36, 42, 48 } },
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		}
	}

	for _,btn in ipairs(button) do
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
	self.colors = {}
end

function Customization:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	self:start()
end

function Customization:setupSystems()
	self.systems = {
		collision = S.collision(),
		gui = S.gui(),
		position = S.position(),
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		cat_fsm = S.cat_fsm("customization"),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
	}

	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.cat_fsm, "changeState")
	self.instance:addSystem(self.systems.cat_fsm, "changePalette")
	self.instance:addSystem(self.systems.cat_fsm, "keypressed")
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
end

function Customization:setupEntities(tag)
	self.entities = {}
	self.entities.cat = ecs.entity()
		:give(C.tag, "cat")
		:give(C.cat)
		:give(C.fsm, "blink", { "attack", "blink", "dizzy", "hurt", "heart", "mouth", "sleep", "snore", "spin"})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.transform, 0, 4, 4, "center", "center")
		:apply()

	self.entities.header = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, -screen.y/2))
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.button, "header", {
				normal = self.images.header,
				textColor = colors("flat", "white", "light"),
				text = "COLOR YOUR CAT!",
				font = self.fonts.header_42,
			})
		:apply()

	self.entities.forward = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.button, "forward", {
				normal = self.images.btn_forward,
				hovered = self.images.btn_forward_hovered,
			})
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, vec2(screen.x * 0.82, screen.y * 1.5))
		:give(C.maxScale, 2.5, 2.5)
		:apply()

	self.entities.back = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.button, "back", {
				normal = self.images.btn_back,
				hovered = self.images.btn_back_hovered,
			})
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.maxScale, 2.5, 2.5)
		:give(C.pos, vec2(screen.x * 0.18, screen.y * 1.5))
		:apply()

		local pos_x = {
			[1] = screen.x * 0.2,
			[2] = screen.x * 0.5,
			[3] = screen.x * 0.8,
		}
		local pos_y = {
			[1] = screen.y * 0.55,
			[2] = screen.y * 0.65,
			[3] = screen.y * 0.75,
			[4] = screen.y * 0.85,
		}

	self.entities.default = E.color_picker(ecs.entity(),
		"source", "default", "yellow", pos_x[1], pos_y[1])
	self.entities.softmilk = E.color_picker(ecs.entity(),
		"softmilk", "softmilk", "softmilk", pos_x[2], pos_y[1])
	self.entities.grayscale = E.color_picker(ecs.entity(),
		"grayscale", "grayscale", "grayscale", pos_x[3], pos_y[1])
	self.entities.red = E.color_picker(ecs.entity(),
		"red", "red", "red", pos_x[1], pos_y[2])
	self.entities.green = E.color_picker(ecs.entity(),
		"green", "green", "green", pos_x[2], pos_y[2])
	self.entities.blue = E.color_picker(ecs.entity(),
		"blue", "blue", "blue", pos_x[3], pos_y[2])
	self.entities.purple = E.color_picker(ecs.entity(),
		"purple", "purple", "purple", pos_x[1], pos_y[3])
	self.entities.black = E.color_picker(ecs.entity(),
		"black", "black", "black", pos_x[2], pos_y[3])
	self.entities.white = E.color_picker(ecs.entity(),
		"white", "white", "white", pos_x[3], pos_y[3])
	self.entities.orange = E.color_picker(ecs.entity(),
		"orange", "orange", "orange", pos_x[2], pos_y[4])

	self.instance:addEntity(self.entities.forward)
	self.instance:addEntity(self.entities.back)
	self.instance:addEntity(self.entities.header)
	self.instance:addEntity(self.entities.cat)
end

function Customization:start()
	event:getName()
	local dur = 0.8
	self.entities.back[C.state].isDisabled = true
	self.entities.forward[C.state].isDisabled = true
	flux.to(self.entities.cat[C.pos].pos, dur, { y = screen.y  * 0.3 }):ease("backout")
	flux.to(self.entities.header[C.pos].pos, dur, { y = 72 }):ease("backout")
	flux.to(self.entities.back[C.pos].pos, dur, { y = screen.y * 0.9 }):ease("backout")
	flux.to(self.entities.forward[C.pos].pos, dur, { y = screen.y * 0.9 }):ease("backout")
		:oncomplete(function()
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
			self.instance:addEntity(self.entities.default)
			self.instance:addEntity(self.entities.softmilk)
			self.instance:addEntity(self.entities.grayscale)
			self.instance:addEntity(self.entities.red)
			self.instance:addEntity(self.entities.green)
			self.instance:addEntity(self.entities.blue)
			self.instance:addEntity(self.entities.purple)
			self.instance:addEntity(self.entities.black)
			self.instance:addEntity(self.entities.white)
			self.instance:addEntity(self.entities.orange)
		end)

	local r = math.random(1, maxPatterns)
	bg.image = self.images["pattern" .. r]
	bg.sx = screen.x/bg.image:getWidth()
	bg.sy = screen.y/bg.image:getHeight()
end

function Customization:update(dt)
	self.instance:emit("update", dt)
end

function Customization:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(bg.image, 0, 0, 0, bg.sx, bg.sy)
	love.graphics.draw(self.images.window, screen.x/2, screen.y - 16, 0,
		2, 2.5,
		self.images.window:getWidth()/2, self.images.window:getHeight())
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Customization:keypressed(key)
	self.instance:emit("keypressed", key)
end

function Customization:exit()
	self.instance:clear()
end

return Customization
