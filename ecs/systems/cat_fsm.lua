local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local lume = require("modules.lume.lume")
local timer = require("modules.hump.timer")
local vec2 = require("modules.hump.vector")
local log = require("modules.log.log")
local resourceManager = require("src.resource_manager")

local CatFSM = System({
		C.fsm,
		C.cat,
	})

local _states = {}
local _palettes = { "grayscale", "source", "softmilk", "green", "blue" }
local cur_state = 1
local cur_pal = 1
local current_pal
local data = {}
local shaders_palette
local time = 0
local timer_activated = false

function CatFSM:init(state)
	self.__state = state
	self.__override = false
	shaders_palette = love.graphics.newShader("shaders/palette_swap.glsl")
	data.speed = {
		attack = 0.3, blink = 0.5, dizzy = 0.5, heart = 0.75,
		hurt = 0.4, mouth = 0.5, sleep = 0.5, snore = 0.8, spin = 1
	}

	data.stopOnLast = {
		attack = true,
		blink = true,
		hurt = true,
		mouth = true,
		sleep = true,
	}

	data.onComplete = {}
	data.onComplete.blink = function()
		local r = math.random(10, 30)/10
		local next_state = lume.randomchoice({ "blink", "mouth" })
		if self.__state == "customization" then
			next_state = lume.randomchoice( { "blink", "mouth", "heart" } )
		end
		timer.after(r, function() self:changeState(next_state) end)
	end
	data.onComplete.mouth = data.onComplete.blink
	data.onComplete.sleep = function() self:overrideState("snore") end
	data.onComplete.heart = function()
		local next_state = lume.weightedchoice({ blink = 30, heart = 70 })
		self:changeState(next_state)
	end
end

function CatFSM:entityAdded(e)
	local c_fsm = e[C.fsm]
	local state = c_fsm.current_state
	for i,v in ipairs(c_fsm.states) do
		assert(resourceManager:getImage("sheet_cat_" .. v), "Sheet does not exist for state: " .. v)
		_states[i] = v
		c_fsm.states[v] = v
	end

	current_pal = _palettes[cur_pal]
	self:changeState(state)
	self:changePalette(current_pal)

	e:give(C.colliderBox, vec2(128, 128), { "point" })
		:give(C.state)
		:apply()
end

function CatFSM:changeState(state)
	if self.__override then return end
	for _,e in ipairs(self.pool) do
		local c_fsm = e[C.fsm]
		if not (c_fsm.states[state]) then error("State does not exist!") end
		c_fsm.current_state = state
		local sheet = resourceManager:getImage("sheet_cat_" .. state)
		local json = "assets/anim/json/cat_" .. state .. ".json"
		local speed = data.speed[state]
		local stopOnLast = data.stopOnLast[state]
		local onComplete = data.onComplete[state]

		e:remove(C.anim):remove(C.anim_callback):apply()
		e:give(C.anim, json, sheet, {speed = speed, stopOnLast = stopOnLast})
			:give(C.anim_callback, { onComplete = onComplete })
			:apply()

		self:changePalette(current_pal)
	end
end

function CatFSM:overrideState(state)
	for _,e in ipairs(self.pool) do
		e:remove(C.anim_callback):apply()
		self.__override = false
		self:changeState(state)
		self.__override = true
	end
end

function CatFSM:changePalette(new_pal)
	for _,e in ipairs(self.pool) do
		local c_fsm = e[C.fsm]
		local state = c_fsm.current_state
		local pal = resourceManager:getImage(("pal_%s_%s"):format(state, new_pal))
		current_pal = new_pal
		print(state, ("pal_%s_%s"):format(state, new_pal))
		e:remove(C.shaders):apply()
		e:give(C.shaders, shaders_palette, "palette", pal):apply()
	end
end

function CatFSM:keypressed(key)
	for _,e in ipairs(self.pool) do
		if key == "up" then
			cur_state = cur_state + 1
			if cur_state > #_states then cur_state = 1 end
		elseif key == "down" then
			cur_state = cur_state - 1
			if cur_state <= 0 then cur_state = #_states end
		elseif key == "left" then
			cur_pal = cur_pal - 1
			if cur_pal <= 0 then cur_pal = #_palettes end
		elseif key == "right" then
			cur_pal = cur_pal + 1
			if cur_pal > #_palettes then cur_pal = 1 end
		end
		if key == "up" or key == "down" or key == "left" or key == "right" then
			self:changePalette(_palettes[cur_pal])
			self:changeState(_states[cur_state])
		end
	end
end

function CatFSM:update(dt)
	for _,e in ipairs(self.pool) do
		local c_collider = e[C.colliderBox]
		local c_state = e[C.state]
		if c_collider.isColliding and not c_state.isClicked and love.mouse.isDown(1) then
			c_state.isClicked = true
			self:onClick(e)
		end
		if not c_state.isHovered then
			c_state.isClicked = false
			time = time + 1 * dt
		else
			time = 0
			timer_activated = false
		end
		if time >= 5 and not timer_activated then
			timer_activated = true
			self:overrideState("sleep")
			log.trace("Cat will now sleep")
		end
	end
end

function CatFSM:onClick(e)
	if self.__state == "customization" then self:changeState("heart") end
end

function CatFSM:onEnter(e)
	if e:has(C.cat) then
		self:overrideState("blink")
		self.__override = false
	end
end

function CatFSM:onExit(e)
	if e:has(C.cat) then
		self:overrideState("mouth")
		self.__override = false
	end
end

return CatFSM
