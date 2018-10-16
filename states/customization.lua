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
local anim_data = require("src.animation_data")

local next_state
local bg = {}

function Customization:init()
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "sheet_cat_attack", path = "assets/anim/cat_attack.png" },
			{ id = "sheet_cat_blink", path = "assets/anim/cat_blink.png" },
			{ id = "sheet_cat_dizzy", path = "assets/anim/cat_dizzy.png" },
			{ id = "sheet_cat_heart", path = "assets/anim/cat_heart.png" },
			{ id = "sheet_cat_hurt", path = "assets/anim/cat_hurt.png" },
			{ id = "sheet_cat_mouth", path = "assets/anim/cat_mouth.png" },
			{ id = "sheet_cat_sleep", path = "assets/anim/cat_sleep.png" },
			{ id = "sheet_cat_snore", path = "assets/anim/cat_snore.png" },
			{ id = "sheet_cat_spin", path = "assets/anim/cat_spin.png" },

			{ id = "pal_attack_source", path = "assets/palettes/source/attack.png" },
			{ id = "pal_blink_source", path = "assets/palettes/source/blink.png" },
			{ id = "pal_dizzy_source", path = "assets/palettes/source/dizzy.png" },
			{ id = "pal_heart_source", path = "assets/palettes/source/heart.png" },
			{ id = "pal_hurt_source", path = "assets/palettes/source/hurt.png" },
			{ id = "pal_mouth_source", path = "assets/palettes/source/mouth.png" },
			{ id = "pal_sleep_source", path = "assets/palettes/source/sleep.png" },
			{ id = "pal_snore_source", path = "assets/palettes/source/snore.png" },
			{ id = "pal_spin_source", path = "assets/palettes/source/spin.png" },
		}
	}
	self.colors = {}
end

function Customization:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.shaders = { palette_swap = love.graphics.newShader("shaders/palette_swap.glsl") }
	self.palettes = {
		self.images.pal_attack_source,
		self.images.pal_blink_source,
		self.images.pal_dizzy_source,
		self.images.pal_heart_source,
		self.images.pal_hurt_source,
		self.images.pal_mouth_source,
		self.images.pal_sleep_source,
		self.images.pal_snore_source,
		self.images.pal_spin_source,
	}

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

function Customization:setupEntities(tag)
	local tag = tag or "dizzy"
	local img = self.images["sheet_cat_" .. tag]
	local json = "assets/anim/json/cat_" .. tag .. ".json"
	local pal = self.images["pal_" .. tag .. "_source"]
	self.entities = {}
	self.entities.character = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 4, 4, "center", "center")
		:give(C.anim, json, img, { speed = anim_data:getSpeed(tag) })
		:give(C.shaders, self.shaders.palette_swap, "palette", pal)
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
		self.instance:removeEntity(self.entities.character)
		self:setupEntities("sleep")
	end
end

function Customization:exit()
	self.instance:clear()
end

return Customization
