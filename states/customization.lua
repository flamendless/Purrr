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
local bg = {}

function Customization:init()
	local states = {"attack","blink","dizzy","heart","hurt","mouth","sleep","snore","spin"}
	local palettes = {"source", "softmilk", "blue", "green"}
	self.assets = {
		images = {
			{ id = "bg_space", path = "assets/images/title_space.png" },
		}
	}
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
	self.instance:addSystem(self.systems.cat_fsm, "draw", "drawDebug")
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
	self.entities.character = ecs.entity()
		:give(C.cat)
		:give(C.fsm, "attack", { "attack", "blink", "dizzy", "hurt", "heart", "mouth", "sleep", "snore", "spin"})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.transform, 0, 4, 4, "center", "center")
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
	self.instance:emit("keypressed", key)
end

function Customization:exit()
	self.instance:clear()
end

return Customization
