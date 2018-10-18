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

local next_state
local bg = {}
local quad
local maxPatterns = 9

function Customization:init()
	local states = {"attack","blink","dizzy","heart","hurt","mouth","sleep","snore","spin"}
	local palettes = {"source", "softmilk", "blue", "green", "grayscale"}
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "header", path = "assets/gui/header.png" },
			{ id = "window", path = "assets/gui/window.png" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
		}
	}

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
		cat_fsm = S.cat_fsm(),
	}

	self.instance:addSystem(self.systems.cat_fsm, "changeState")
	self.instance:addSystem(self.systems.cat_fsm, "changePalette")
	self.instance:addSystem(self.systems.cat_fsm, "keypressed")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint")
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
				text = "CUSTOMIZE YOUR CAT",
				font = self.fonts.header_42,
			})
		:apply()

	self.entities.forward = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.button, "forward", {
				normal = self.images.forward,
				hovered = self.images.forward_hovered,
			})
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, vec2(screen.x * 0.75, screen.y * 1.5))
		:apply()

	self.entities.back = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.button, "back", {
				normal = self.images.back,
				hovered = self.images.back,
			})
		:give(C.transform, 0, 2, 2, "center", "center")
		:give(C.pos, vec2(screen.x * 0.25, screen.y * 1.5))
		:apply()

	self.instance:addEntity(self.entities.forward)
	self.instance:addEntity(self.entities.back)
	self.instance:addEntity(self.entities.header)
	self.instance:addEntity(self.entities.cat)
end

function Customization:start()
	local dur = 0.8
	flux.to(self.entities.cat[C.pos].pos, dur, { y = screen.y  * 0.4 }):ease("backout")
	flux.to(self.entities.header[C.pos].pos, dur, { y = 72 }):ease("backout")

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
		2, 2,
		self.images.window:getWidth()/2, self.images.window:getHeight())
	self.instance:emit("draw")
end

function Customization:keypressed(key)
	self.instance:emit("keypressed", key)
end

function Customization:exit()
	self.instance:clear()
end

return Customization
