local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local lume = require("modules.lume.lume")

local Instance = require("modules.concord.lib.instance")
local Entity = require("modules.concord.lib.entity")
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local bgm = require("src.bgm")
local data = require("src.data")
local transition = require("src.transition")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local assets = require("src.assets")
local pos = require("src.positions")

function Menu:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.sources = resourceManager:getAll("sources")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = Instance()
	self:setupSystems()
	self:setupEntities()
	self:start()

	bgm:start(self.sources.bgm_menu)
end

function Menu:setupSystems()
	self.systems = {
		renderer_bg = S.renderer.bg(),
		renderer_sprite = S.renderer.sprite(),
		collider = S.collider(),
		gui = S.gui(),
	}
	if __isDesktop then self.instance:addSystem(self.systems.collider, "mousepressed")
	elseif __isMobile then self.instance:addSystem(self.systems.collider, "touchpressed")
	end
	self.instance:addSystem(self.systems.renderer_bg, "draw")
	self.instance:addSystem(self.systems.renderer_sprite, "draw")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "mousepressed")

	if __debug then
		self.instance:addSystem(self.systems.collider, "draw")
	end
end

function Menu:setupEntities()
	self.entities = {}
	self.entities.bg = Entity():give(C.background, self.images.bg):apply()
	self.entities.title = Entity()
		:give(C.tag, "title")
		:give(C.color)
		:give(C.sprite, self.images.title)
		:give(C.transform, vec2(screen.x/2, -screen.y/2), 0, 1, 1, self.images.title:getWidth()/2, self.images.title:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.entities.btn_start = Entity()
		:give(C.tag, "btn_start")
		:give(C.color)
		:give(C.gui_button)
		:give(C.gui_onClick, function()
				--TODO replace splash
				gamestate:switch( require("states").splash )
			end)
		:give(C.onHoveredSprite, self.images.btn_start_hovered)
		:give(C.sprite, self.images.btn_start)
		:give(C.transform, vec2(screen.x/2, screen.y * 1.5), 0, 3, 3, self.images.btn_start:getWidth()/2, self.images.btn_start:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.entities.btn_leave = Entity()
		:give(C.tag, "btn_leave")
		:give(C.color)
		:give(C.gui_button)
		:give(C.gui_onClick, function()
				love.event.quit()
			end)
		:give(C.onHoveredSprite, self.images.btn_leave_hovered)
		:give(C.sprite, self.images.btn_leave)
		:give(C.transform, vec2(screen.x/2, screen.y * 1.5), 0, 2, 2, self.images.btn_leave:getWidth()/2, self.images.btn_leave:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.entities.btn_settings = Entity()
		:give(C.tag, "btn_settings")
		:give(C.color)
		:give(C.gui_button)
		:give(C.gui_onClick, function()
			end)
		:give(C.onHoveredSprite, self.images.btn_settings_hovered)
		:give(C.sprite, self.images.btn_settings)
		:give(C.transform, vec2(screen.x - 32, screen.y * 1.5), 0, 2, 2, self.images.btn_settings:getWidth(), self.images.btn_settings:getHeight())
		:give(C.collider_sprite)
		:apply()

	self.instance:addEntity(self.entities.bg)
	self.instance:addEntity(self.entities.title)
	self.instance:addEntity(self.entities.btn_start)
	self.instance:addEntity(self.entities.btn_leave)
	self.instance:addEntity(self.entities.btn_settings)
end

function Menu:start()
	local title_y = self.entities.title[C.transform].oy + 32
	local btn_start_y = self.entities.btn_start[C.transform].oy + 455
	local btn_leave = self.entities.btn_leave[C.transform].oy + 620
	local btn_settings = screen.y - screen.pad
	flux.to(self.entities.title[C.transform].pos, 1, { y = title_y }):ease("backout")
	flux.to(self.entities.btn_start[C.transform].pos, 1, { y = btn_start_y }):ease("backout")
	flux.to(self.entities.btn_leave[C.transform].pos, 1, { y = btn_leave }):ease("backout")
	flux.to(self.entities.btn_settings[C.transform].pos, 1, { y = btn_settings }):ease("backout")
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.instance:emit("draw")
end

function Menu:keypressed(key)
	self.instance:emit("keypressed", key)
end

function Menu:mousepressed(mx, my, mb)
	self.instance:emit("mousepressed", mx, my, mb)
end

function Menu:touchpressed(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchpressed", id, tx, ty, dx, dy, pressure)
end

function Menu:textinput(t)
	self.instance:emit("textinput", t)
end

function Menu:exit()
	bgm:clear()
	if self.instance then self.instance:clear() end
end

return Menu
