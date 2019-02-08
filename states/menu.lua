local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local lume = require("modules.lume.lume")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local data = require("src.data")
local transition = require("src.transition")
local event = require("src.event")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local assets = require("src.assets")
local pos = require("src.positions")

function Menu:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	self:start()
end

function Menu:setupSystems()
	self.systems = {
		renderer_bg = S.renderer.bg(),
		renderer_sprite = S.renderer.sprite(),
		collider = S.collider(),
		gui = S.gui(),
	}
	self.instance:addSystem(self.systems.renderer_bg, "draw")
	self.instance:addSystem(self.systems.renderer_sprite, "draw")
	self.instance:addSystem(self.systems.collider, "mousepressed")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "mousepressed")

	if __debug then
		self.instance:addSystem(self.systems.collider, "draw")
	end
end

function Menu:setupEntities()
	self.entities = {}
	self.entities.bg = ecs.entity():give(C.background, self.images.bg):apply()
	self.entities.title = ecs.entity()
		:give(C.tag, "title")
		:give(C.sprite, self.images.title)
		:give(C.transform, vec2(screen.x/2, -screen.y/2), 0, 1, 1, self.images.title:getWidth()/2, self.images.title:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.entities.btn_play = ecs.entity()
		:give(C.tag, "btn_play")
		:give(C.gui_button)
		:give(C.gui_onClick, function()
				gamestate:switch( require("states").splash )
			end)
		:give(C.onHoveredSprite, self.images.btn_play_hovered)
		:give(C.sprite, self.images.btn_play)
		:give(C.transform, vec2(screen.x/2, screen.y * 1.5), 0, 3, 3, self.images.btn_play:getWidth()/2, self.images.btn_play:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.entities.btn_leave = ecs.entity()
		:give(C.tag, "btn_leave")
		:give(C.gui_button)
		:give(C.gui_onClick, function()
				love.event.quit()
			end)
		:give(C.onHoveredSprite, self.images.btn_leave_hovered)
		:give(C.sprite, self.images.btn_leave)
		:give(C.transform, vec2(screen.x/2, screen.y * 1.5), 0, 2, 2, self.images.btn_leave:getWidth()/2, self.images.btn_leave:getHeight()/2)
		:give(C.collider_sprite)
		:apply()

	self.instance:addEntity(self.entities.bg)
	self.instance:addEntity(self.entities.title)
	self.instance:addEntity(self.entities.btn_play)
	self.instance:addEntity(self.entities.btn_leave)
end

function Menu:start()
	local title_y = self.entities.title[C.transform].oy + 32
	local btn_play_y = self.entities.btn_play[C.transform].oy + 455
	local btn_leave = self.entities.btn_leave[C.transform].oy + 620
	flux.to(self.entities.title[C.transform].pos, 1, { y = title_y }):ease("backout")
	flux.to(self.entities.btn_play[C.transform].pos, 1, { y = btn_play_y }):ease("backout")
	flux.to(self.entities.btn_leave[C.transform].pos, 1, { y = btn_leave }):ease("backout")
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

function Menu:textinput(t)
	self.instance:emit("textinput", t)
end

function Menu:exit()
	if self.instance then self.instance:clear() end
end

return Menu
