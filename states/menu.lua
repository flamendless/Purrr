local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local coil = require("modules.coil.coil")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")

local transition = require("src.transition")
local event = require("src.event")
local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")

function Menu:init()
	self.assets = {
		images = {
			{ id = "button", path = "assets/gui/button_yellow.png" },
			{ id = "hovered_button", path = "assets/gui/button_yellow_hovered.png" },
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
		},
		fonts = {
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		}
	}
	self.colors = {
		bg = colors("flat", "black", "dark"),
	}
end

function Menu:enter(previous, ...)
	self.instance = ecs.instance()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.systems = {
		collision = S.collision(),
		follow = S.follow(),
		gui = S.gui(),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
		position = S.position(),
		renderer = S.renderer(),
		transform = S.transform(),
	}

	self.entities = {}
	self.entities.btn_play = ecs.entity()
		:give(C.button, "play",
			{
				text = "PLAY",
				font = self.fonts.upheaval_42,
				textColor = colors("flat", "white", "light"),
				hoveredTextColor = colors("flat", "white", "dark"),
				normal = self.images.button,
				hovered = self.images.hovered_button,
				onClick = function()
					transition:start( require("states").menu )
				end
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 1, 1, "center", "center")
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.maxScale, 1.25, 1.25)
		:give(C.windowIndex, 1)
		:apply()

	self.entities.btn_quit = ecs.entity()
		:give(C.button, "quit",
		{
			text = "QUIT",
			font = self.fonts.upheaval_42,
			textColor = colors("flat", "white", "light"),
			hoveredTextColor = colors("flat", "white", "dark"),
			normal = self.images.button,
			hovered = self.images.hovered_button,
			onClick = function()
				event:showExitConfirmation()
			end
		})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y * 1.75))
		:give(C.transform, 0, 1, 1, "center", "center")
		:give(C.maxScale, 1.25, 1.25)
		:give(C.follow, self.entities.btn_play)
		:give(C.offsetPos, vec2(0, 96))
		:give(C.windowIndex, 1)
		:apply()

	self.instance:addEntity(self.entities.btn_play)
	self.instance:addEntity(self.entities.btn_quit)

	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.collision, "draw", "draw")

	self:start()
end

function Menu:start()
	local dur = 1
	coil.add(function()
		flux.to(self.entities.btn_play[C.pos].pos, dur, { y = screen.y * 0.75 })
			:ease("backout")
			:oncomplete(function()
				self.entities.btn_quit:remove(C.follow):apply()
				self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
			end)
	end)
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.colors.bg:setBG()
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Menu:exit()
	self.instance:clear()
end

return Menu
