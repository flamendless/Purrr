local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local S = require("ecs.systems")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local gamestate = require("src.gamestate")
local screen = require("src.screen")
local colors = require("src.colors")

local Window = {}

local dur = 0.75
local temp_window

function Window:load(args)
	local sx = 4
	local sy = 4
	temp_window = __window
	__window = 2
	self.instance = ecs.instance()
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
	self.entities.main_window = ecs.entity()
		:give(C.color, colors(1, 1, 1, 1))
		:give(C.sprite, args.spr_window)
		:give(C.pos, vec2(screen.x/2, screen.y * 1.5))
		:give(C.transform, 0, sx, sy, "center", "center")
		:give(C.windowIndex, __window)
		:apply()

	if args.str_title then
		self.entities.title_text = ecs.entity()
			:give(C.window)
			:give(C.color, colors("flat", "white", "light"))
			:give(C.text, args.str_title, args.font_title, "center", args.spr_window:getWidth() * sx)
			:give(C.pos, vec2(0, 0))
			:give(C.parent, self.entities.main_window)
			:give(C.offsetPos, vec2(0, 64))
			:apply()
	end

	if args.str_content then
		local x_pad = 16
		self.entities.content_text = ecs.entity()
			:give(C.window)
			:give(C.color, colors("flat", "white", "light"))
			:give(C.textPad, vec2(16, 0))
			:give(C.text, args.str_content, args.font_content, "center", args.spr_window:getWidth() * sx)
			:give(C.pos, vec2(0, 0))
			:give(C.parent, self.entities.main_window)
			:give(C.offsetPos, vec2(0, 256))
			:apply()
	end

	if args.button1 then
		self.entities.btn1 = ecs.entity()
			:give(C.button, args.button1.id or "button1",
				{
					text = args.button1.text,
					font = args.button1.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.button1.normal,
					hovered = args.button1.hovered,
					onClick = args.button1.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 1, 1, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 1.25, 1.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(args.spr_window:getWidth() * sx/4, 256))
			:apply()
	end

	if args.button2 then
		self.entities.btn2 = ecs.entity()
			:give(C.button, args.button2.id or "button2",
				{
					text = args.button2.text,
					font = args.button2.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.button2.normal,
					hovered = args.button2.hovered,
					onClick = args.button2.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 1, 1, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 1.25, 1.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(
				-args.button2.normal:getWidth() * sx/5,
				256))
			:apply()
	end

	for k,v in pairs(self.entities) do
		self.instance:addEntity(v)
	end

	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.collision, "draw", "draw")

	self:start()
end

function Window:start()
	flux.to(self.entities.main_window[C.pos].pos, dur, { x = screen.x/2, y = screen.y/2 })
		:ease("backout")
		:oncomplete(function()
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
		end)
end

function Window:update(dt)
	self.instance:emit("update", dt)
end

function Window:draw()
	self.instance:emit("draw")
end

function Window:keypressed(key)
	if key == "escape" then
		self:close()
	end
end

function Window:close()
	for k,v in pairs(self.entities) do
		v:remove(C.colliderBox):apply()
	end
	flux.to(self.entities.main_window[C.pos].pos, dur, { x = screen.x/2, y = -screen.y })
		:ease("backin")
		:oncomplete(function()
			gamestate:removeInstance(self.id)
		end)
end

function Window:exit()
	self.instance:clear()
	__window = temp_window
end

return Window
