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

local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

local next_state
local index = 1
local bg = {}

function Customization:init()
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "sheet_cat_blink", path = "assets/anim/cat_blink.png" },
			{ id = "pal_cat_original", path = "assets/palettes/cat_original.png" },
			{ id = "pal_cat_softmilk", path = "assets/palettes/cat_softmilk.png" },
			{ id = "pal_cat_gbct", path = "assets/palettes/cat_gbct.png" },
			{ id = "pal_cat_journey", path = "assets/palettes/cat_journey.png" },
			{ id = "pal_cat_blue", path = "assets/palettes/cat_blue.png" },
			{ id = "pal_cat_green", path = "assets/palettes/cat_green.png" },
			{ id = "pal_cat_red", path = "assets/palettes/cat_red.png" },
			{ id = "pal_cat_purple", path = "assets/palettes/cat_purple.png" },
		}
	}
	self.colors = {}
end

function Customization:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.shaders = { palette_swap = love.graphics.newShader("shaders/palette_swap.glsl") }
	self.palettes = {
		self.images.pal_cat_original,
		self.images.pal_cat_softmilk,
		self.images.pal_cat_gbct,
		self.images.pal_cat_journey,
		self.images.pal_cat_blue,
		self.images.pal_cat_green,
		self.images.pal_cat_purple,
		self.images.pal_cat_red,
	}
	self.index = { "original", "softmilk", "gameboy", "journey", "blue", "green", "purple", "red" }

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
	}
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

function Customization:setupEntities()
	self.entities = {}
	self.entities.character = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 4, 4, "center", "center")
		:give(C.anim, "assets/anim/cat_blink.json", self.images.sheet_cat_blink, { tag = "blink", speed = 0.25 })
		:give(C.shaders, self.shaders.palette_swap, "palette", self.images.pal_cat_original)
		:apply()

	self.instance:addEntity(self.entities.character)
end

function Customization:start()
	bg.image = self.images.bg_space
	bg.sx = screen.x/bg.image:getWidth()
	bg.sy = screen.y/bg.image:getHeight()
end

function Customization:update(dt)
	self.instance:emit("update", dt)
end

function Customization:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(bg.image, 0, 0, 0, bg.sx, bg.sy)
	self.instance:emit("draw")
end

function Customization:keypressed(key)
	if key == "s" then
		index = index + 1
		if index > #self.palettes then
			index = 1
		end
		local current = self.palettes[index]
		self.entities.character:remove(C.shaders):apply()
		self.entities.character:give(C.shaders, self.shaders.palette_swap, "palette", current):apply()
	end
end

function Customization:exit()
	self.instance:clear()
end

return Customization
