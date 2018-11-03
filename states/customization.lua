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
local log = require("modules.log.log")
local timer = require("modules.hump.timer")
local lume = require("modules.lume.lume")

local colors = require("src.colors")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local event = require("src.event")
local data = require("src.data")
local transition = require("src.transition")
local soundManager = require("src.sound_manager")
local assets = require("src.assets")
local pos = require("src.positions")

local next_state
local level = 1
local window = { y = screen.y - 16 }

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
		customize_cat = S.customize_cat(),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
	}

	self.instance:addSystem(self.systems.renderer, "draw", "drawBG")
	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.customize_cat, "changeState")
	self.instance:addSystem(self.systems.customize_cat, "changePalette")
	self.instance:addSystem(self.systems.customize_cat, "keypressed")
	self.instance:addSystem(self.systems.customize_cat, "update")
	self.instance:addSystem(self.systems.customize_cat, "onEnter")
	self.instance:addSystem(self.systems.customize_cat, "onExit")
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
	self.btns = {}
	self.btns.default = E.color_picker(ecs.entity(), "source", "default", "yellow")
	self.btns.softmilk = E.color_picker(ecs.entity(), "softmilk", "softmilk", "softmilk")
	self.btns.grayscale = E.color_picker(ecs.entity(), "grayscale", "grayscale", "grayscale")
	self.btns.red = E.color_picker(ecs.entity(), "red", "red", "red")
	self.btns.green = E.color_picker(ecs.entity(), "green", "green", "green")
	self.btns.blue = E.color_picker(ecs.entity(), "blue", "blue", "blue")
	self.btns.purple = E.color_picker(ecs.entity(), "purple", "purple", "purple")
	self.btns.black = E.color_picker(ecs.entity(), "black", "black", "black")
	self.btns.white = E.color_picker(ecs.entity(), "white", "white", "white")
	self.btns.orange = E.color_picker(ecs.entity(), "orange", "orange", "orange")

	for k,v in pairs(self.btns) do self.instance:addEntity(v) end

	self.entities = {}
	self.entities.bg = E.pattern(ecs.entity())
	self.entities.cat = E.cat(ecs.entity())
	self.entities.header = E.header(ecs.entity(), "CUSTOMIZATION")
	self.entities.forward = E.button_forward(ecs.entity())
		:give(C.onClick, function() self:forward() end)
		:give(C.pos, pos.customization.off_forward:clone())
		:apply()
	self.entities.back = E.button_back(ecs.entity())
		:give(C.onClick, function() self:back() end)
		:give(C.pos, pos.customization.off_back:clone())
		:apply()

	self.accessories = {}
	self.accessories.notice = E.notice(ecs.entity())
	self.accessories.lock = E.lock(ecs.entity())

	self.instance:addEntity(self.entities.bg)
	self.instance:addEntity(self.accessories.notice)
	self.instance:addEntity(self.accessories.lock)
	self.instance:addEntity(self.entities.forward)
	self.instance:addEntity(self.entities.back)
	self.instance:addEntity(self.entities.header)
	self.instance:addEntity(self.entities.cat)
end

function Customization:start()
	if not data.data.got_name then event:getName() end
	local dur = 0.8
	self.entities.back[C.state].isDisabled = true
	self.entities.forward[C.state].isDisabled = true
	flux.to(self.entities.cat[C.pos].pos, dur, { y = pos.customization.cat:clone().y }):ease("backout")
	flux.to(self.entities.header[C.pos].pos, dur, { y = pos.customization.header:clone().y }):ease("backout")
	flux.to(self.entities.back[C.pos].pos, dur, { y = pos.customization.back:clone().y }):ease("backout")
	flux.to(self.entities.forward[C.pos].pos, dur, { y = pos.customization.forward:clone().y }):ease("backout")
		:oncomplete(function()
			self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
		end)
	for k,v in pairs(self.btns) do
		local c_pos = v[C.pos].pos
		flux.to(c_pos, dur, { y = pos.color_picker[k]:clone().y }):ease("backout")
	end
end

function Customization:update(dt)
	self.instance:emit("update", dt)
end

function Customization:draw()
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Customization:keypressed(key)
	if key == "escape" then
		event:showHomeConfirmation()
	end
	self.instance:emit("keypressed", key)
end

function Customization:touchreleased(id, tx, ty, dx, dy, pressure)
	self.instance:emit("touchreleased", id, tx, ty, dx, dy, pressure)
end

function Customization:exit()
	if self.instance then self.instance:clear() end
	data.data.customization = false
	data.data.new_game = false
	data.data.got_name = true
	data:save()
end

function Customization:forward()
	if level == 1 then
		level = 2
		log.trace(("Cat Name: %s -> Palette: %s"):format(data.data.palette, data.data.cat_name))
		self.instance:emit("changeState", "hurt")
		self.instance:disableSystem(self.systems.collision, "update", "checkPoint")
		for k,v in pairs(self.btns) do
			flux.to(v[C.pos].pos, 1, { x = pos.screen.left:clone().x }):ease("backin")
				:oncomplete(function()
					self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
					self.entities.back[C.state].isDisabled = false
					if level == 2 then
						flux.to(self.accessories.notice[C.pos].pos, 1, { x = pos.customization.notice:clone().x }):ease("backout")
						flux.to(self.accessories.lock[C.pos].pos, 1, { x = pos.customization.lock:clone().x }):ease("backout")
					end
				end)
		end

	elseif level == 2 then
		self.instance:disableSystem(self.systems.collision, "update", "checkPoint")
		flux.to(self.accessories.notice[C.pos].pos, 1, { x = pos.customization.off_notice:clone().x }):ease("backin")
		flux.to(self.accessories.lock[C.pos].pos, 1, { x = pos.customization.off_lock:clone().x }):ease("backin")
			:oncomplete(function()
				self.instance:emit("changeState", "blink")
				flux.to(window, 1, { y = screen.y * 2 }):ease("backin")
				flux.to(self.entities.back[C.pos].pos, 1, { y = pos.customization.off_back:clone().y }):ease("backin")
				flux.to(self.entities.forward[C.pos].pos, 1, { y = pos.customization.off_forward:clone().y }):ease("backin")
				flux.to(self.entities.header[C.pos].pos, 1, { y = pos.customization.off_header:clone().y }):ease("backin")
					:oncomplete(function()
						self.instance:emit("changeState", "blink")
						timer.after(1, function()
							self.instance:emit("changeState", "spin")
							flux.to(self.entities.cat[C.pos].pos, 2, { y = pos.customization.off_cat:clone().y }):ease("backin")
								:oncomplete(function()
									transition:start( require("states.lobby") )
								end)
						end)
					end)
			end)
	end
end

function Customization:back()
	if level == 2 then
		level = 1
		flux.to(self.accessories.notice[C.pos].pos, 1, { x = pos.customization.off_notice:clone().x }):ease("backin")
		flux.to(self.accessories.lock[C.pos].pos, 1, { x = pos.customization.off_lock:clone().x }):ease("backin")
			:oncomplete(function()
				self.instance:emit("changeState", "blink")
				self.instance:disableSystem(self.systems.collision, "update", "checkPoint")
				for k,v in pairs(self.btns) do
					flux.to(v[C.pos].pos, 1, { x = pos.color_picker[k]:clone().x }):ease("backout")
						:oncomplete(function()
							self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
						end)
				end
			end)
	end
end

return Customization
