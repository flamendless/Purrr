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
local event = require("src.event")
local data = require("src.data")

local Window = {}

local keyboard = false
local dur = 0.75
local temp_window

function Window:load(args)
	local sx = 4
	local sy = 4
	temp_window = __window
	__window = 2
	if args.sx then sx = args.sx end
	if args.sy then sy = args.sy end
	self.canClose = false
	self.uncloseable = args.uncloseable
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
		textinput = S.textinput(),
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
			:give(C.offsetPos, vec2(0, args.title_offset_y or 64))
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
			:give(C.offsetPos, vec2(0, args.content_offset_y or 256))
			:apply()
	end

	if args.button1 then
		local btn1_sx = 2
		local btn1_sy = 2
		if args.button1.scalex then btn1_sx = args.button1.scalex end
		if args.button1.scaley then btn1_sy = args.button1.scaley end
		self.entities.btn1 = ecs.entity()
			:give(C.button, args.button1.id or "button1",
				{
					disabled = args.button1.disabled,
					text = args.button1.text,
					font = args.button1.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.button1.normal,
					hovered = args.button1.hovered,
					onClick = args.button1.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, btn1_sx, btn1_sy, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, btn1_sx + 0.25, btn1_sy + 0.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(args.spr_window:getWidth() * sx/4, 256))
			:apply()
	end

	if args.middleButton then
		self.entities.middleBtn = ecs.entity()
			:give(C.button, args.middleButton.id or "middleButton",
				{
					disabled = args.middleButton.disabled,
					text = args.middleButton.text,
					font = args.middleButton.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.middleButton.normal,
					hovered = args.middleButton.hovered,
					onClick = args.middleButton.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 2.25, 2.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(0, 256))
			:apply()
	end

	if args.insideButton then
		self.entities.insideBtn = ecs.entity()
			:give(C.button, args.insideButton.id or "insideButton",
				{
					disabled = args.insideButton.disabled,
					text = args.insideButton.text,
					font = args.insideButton.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.insideButton.normal,
					hovered = args.insideButton.hovered,
					onClick = args.insideButton.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 2.25, 2.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(0, 0))
			:apply()
	end

	if args.insideButton2 then
		self.entities.insideButton2 = ecs.entity()
			:give(C.button, args.insideButton2.id or "insideButton2",
				{
					disabled = args.insideButton2.disabled,
					text = args.insideButton2.text,
					font = args.insideButton2.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.insideButton2.normal,
					hovered = args.insideButton2.hovered,
					onClick = args.insideButton2.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 2.25, 2.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(-128))
			:apply()
	end

	if args.insideButton3 then
		self.entities.insideButton3 = ecs.entity()
			:give(C.button, args.insideButton3.id or "insideButton3",
				{
					disabled = args.insideButton3.disabled,
					text = args.insideButton3.text,
					font = args.insideButton3.font,
					textColor = colors("flat", "white", "light"),
					hoveredTextColor = colors("flat", "white", "dark"),
					normal = args.insideButton3.normal,
					hovered = args.insideButton3.hovered,
					onClick = args.insideButton3.onClick,
				})
			:give(C.color, colors("white"))
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 2.25, 2.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(128))
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
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2())
			:give(C.maxScale, 2.25, 2.25)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(
				-args.button2.normal:getWidth() * sx/2, 256))
			:apply()
	end

	if args.textinput then
		local str = data.data.cat_name or "NAME"
		self.entities.textinput = ecs.entity()
			:give(C.textinput)
			:give(C.color, colors("white"))
			:give(C.pos, vec2())
			:give(C.text, str, args.textinput.font, "center", screen.x - 64)
			:give(C.windowIndex, __window)
			:give(C.follow, self.entities.main_window)
			:give(C.offsetPos, vec2(-args.spr_window:getWidth(), -args.spr_window:getHeight()/2))
			:apply()
	end

	for k,v in pairs(self.entities) do
		self.instance:addEntity(v)
	end

	self.instance:addSystem(self.systems.textinput, "update")
	self.instance:addSystem(self.systems.textinput, "textinput")
	self.instance:addSystem(self.systems.textinput, "keypressed")
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
			self.canClose = true
			if self.entities.textinput then
				self:showKeyboard()
			end
		end)
end

function Window:listen(msg, ...)
	if msg == "enableAcceptButton" then
		self.entities.btn1[C.state].isDisabled = false
	elseif msg == "disableAcceptButton" then
		self.entities.btn1[C.state].isDisabled = true
	elseif msg == "saveName" then
		local str = self.entities.textinput[C.text].text
		data.data.cat_name = str
	end
end

function Window:update(dt)
	self.instance:emit("update", dt)
end

function Window:draw()
	self.instance:emit("draw")
end

function Window:keypressed(key)
	if key == "escape" then
		if self.canClose then
			if not self.uncloseable then
				self:close()
			end
		end
	end
	self.instance:emit("keypressed", key)
end

function Window:textinput(t)
	self.instance:emit("textinput", t)
end

function Window:touchpressed(id, tx, ty, dx, dy, pressure)
	if not keyboard then
		self:showKeyboard()
	end
end

function Window:showKeyboard()
	love.keyboard.setTextInput(true)
	keyboard = true
end

function Window:hideKeyboard()
	love.keyboard.setTextInput(false)
	keyboard = false
end

function Window:close()
	self:hideKeyboard()
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
	love.keyboard.setKeyRepeat(false)
	-- self.instance:clear()
	__window = temp_window
	event:reset()
end

return Window
