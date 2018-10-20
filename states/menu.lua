local BaseState = require("states.base_state")
local Menu = BaseState("Menu")

local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
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

local next_state
local bg = {}

function Menu:init()
	self.assets = {
		images = {
			{ id = "title", path = "assets/images/title.png" },
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "bg", path = "assets/images/bg.png" },
			{ id = "btn_play", path = "assets/gui/play.png" },
			{ id = "btn_play_hovered", path = "assets/gui/play_hovered.png" },
			{ id = "btn_leave", path = "assets/gui/leave.png" },
			{ id = "btn_leave_hovered", path = "assets/gui/leave_hovered.png" },
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
			{ id = "button_accept", path = "assets/gui/button_accept.png" },
			{ id = "button_accept_hovered", path = "assets/gui/button_accept_hovered.png" },
			{ id = "button_back", path = "assets/gui/button_back.png" },
			{ id = "button_back_hovered", path = "assets/gui/button_back_hovered.png" },
			{ id = "button_cancel", path = "assets/gui/button_cancel.png" },
			{ id = "button_cancel_hovered", path = "assets/gui/button_cancel_hovered.png" },
			{ id = "items_base", path = "assets/gui/items_base.png" },
			{ id = "items_base_hovered", path = "assets/gui/items_base_hovered.png" },
		},
		fonts = {
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		},
		sources = {
			{ id = "sfx_transition", path = "assets/sounds/cat/deep_meow.ogg", kind = "stream" },
		}
	}
	for i = 1, 4 do
		local id = "window_settings" .. i
		local path = "assets/gui/" .. id .. ".png"
		table.insert(self.assets.images, { id = id, path = path })
	end

	assets:getMusic(self.assets)

	self.colors = {
		bg = colors("flat", "black", "dark"),
	}
end

function Menu:enter(previous, ...)
	event:setup()
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	self.instance:addEntity(self.entities.btn_play)
	self.instance:addEntity(self.entities.btn_quit)
	self.instance:addEntity(self.entities.title)
	self:start()
end

function Menu:setupSystems()
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
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.follow, "update")
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
end

function Menu:setupEntities()
	self.entities = {}
	self.entities.btn_play = ecs.entity()
		:give(C.button, "Play",
			{
				normal = self.images.btn_play,
				hovered = self.images.btn_play_hovered,
				onClick = function()
					transition:start(next_state)
				end
			})
		:give(C.color, colors("white"))
		:give(C.transform, 0, 3, 3, "center", "center")
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.maxScale, 2.5, 2.5)
		:give(C.windowIndex, 1)
		:apply()

	self.entities.btn_quit = ecs.entity()
		:give(C.button, "Quit",
		{
			normal = self.images.btn_leave,
			hovered = self.images.btn_leave_hovered,
			onClick = function()
				event:showExitConfirmation()
			end
		})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, screen.y * 1.75))
		:give(C.transform, 0, 1.5, 1.5, "center", "center")
		:give(C.maxScale, 1.25, 1.25)
		:give(C.follow, self.entities.btn_play)
		:give(C.offsetPos, vec2(0, 148))
		:give(C.windowIndex, 1)
		:apply()

	self.entities.title = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.sprite, self.images.title)
		:give(C.pos, vec2(screen.x/2, -screen.y/2))
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()
end

function Menu:start()
	local dur = 1
	flux.to(self.entities.title[C.pos].pos, dur, { y = screen.y * 0.25 }):ease("backout")
	flux.to(self.entities.btn_play[C.pos].pos, dur, { y = screen.y * 0.65 })
		:ease("backout")
		:oncomplete(function()
			self.entities.btn_quit:remove(C.follow):apply()
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
		end)

	if data.data.new_game then
		next_state = require("states.intro")
	else
		if data.data.customization then
			next_state = require("states.customization")
		else
			next_state = require("states.lobby")
		end
	end
	bg.image = self.images.bg
	bg.sx = screen.x/bg.image:getWidth()
	bg.sy = screen.y/bg.image:getHeight()
end

function Menu:update(dt)
	self.instance:emit("update", dt)
end

function Menu:draw()
	self.colors.bg:setBG()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(bg.image, 0, 0, 0, bg.sx, bg.sy)
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Menu:exit()
	self.instance:clear()
end

return Menu
