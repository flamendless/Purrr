local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local lume = require("modules.lume.lume")
local timer = require("modules.hump.timer")
local vec2 = require("modules.hump.vector")
local log = require("modules.log.log")
local resourceManager = require("src.resource_manager")
local data = require("src.data")

local CustomizeCat = System({
		C.fsm,
		C.cat,
	})

local _states = {}
local _palettes = { "grayscale", "source", "softmilk", "green", "blue" }
local cur_state = 1
local cur_pal = 1
local current_pal
local _data = {}
local shaders_palette
local max_heart_count = 3
local heart_count = 3

function CustomizeCat:init()
	shaders_palette = love.graphics.newShader("shaders/palette_swap.glsl")
	_data.speed = { blink = 0.5, heart = 0.75, hurt = 0.4, mouth = 0.5, sleep = 0.5, snore = 0.8, spin = 1.5 }

	_data.stopOnLast = {
		blink = true,
		mouth = true,
		sleep = true,
	}

	_data.onComplete = {}
	_data.onComplete.blink = function(e)
		local r = math.random(10, 30)/10
		local next_state = lume.randomchoice({ "blink", "mouth" })
		next_state = lume.randomchoice( { "blink", "mouth", "heart" } )
		timer.after(r, function()
			if e[C.fsm].current_state == "hurt" then
			elseif e[C.fsm].current_state == "spin" then
			else
				self:changeState(next_state)
			end
		end)
	end
	_data.onComplete.mouth = _data.onComplete.blink
	_data.onComplete.sleep = function() self:changeState("snore") end
	_data.onComplete.heart = function(e)
		heart_count = heart_count - 1
		if heart_count <= 0 then
			self:changeState("blink")
			heart_count = max_heart_count
		end
	end
	_data.onComplete.hurt = function(e)
		local c_anim = e[C.anim].anim
		c_anim:setFrame(4)
	end
end

function CustomizeCat:entityAdded(e)
	local c_fsm = e[C.fsm]
	local state = c_fsm.current_state
	for i,v in ipairs(c_fsm.states) do
		assert(resourceManager:getImage("sheet_cat_" .. v), "Sheet does not exist for state: " .. v)
		_states[i] = v
		c_fsm.states[v] = v
	end

	current_pal = _palettes[cur_pal]
	self:changeState(state)

	if data.data.palette then
		current_pal = data.data.palette
	end
	self:changePalette(current_pal)

	e:give(C.colliderBox, vec2(128, 128), { "point" })
		:give(C.state)
		:apply()

	timer.after(5, function()
		if e[C.fsm].current_state == "hurt" or e[C.fsm].current_state == "heart" or e[C.fsm].current_state == "spin" then return end
		self:changeState("sleep")
	end)
end

function CustomizeCat:changeState(state)
	for _,e in ipairs(self.pool) do
		local c_fsm = e[C.fsm]
		if not (c_fsm.states[state]) then error("State does not exist!") end
		c_fsm.previous_state = c_fsm.current_state
		c_fsm.current_state = state
		local sheet = resourceManager:getImage("sheet_cat_" .. state)
		local json = "assets/anim/json/cat_" .. state .. ".json"
		local speed = _data.speed[state]
		local stopOnLast = _data.stopOnLast[state]
		local onComplete = _data.onComplete[state]

		e:remove(C.anim):remove(C.anim_callback):apply()
		e:give(C.anim, json, sheet, {speed = speed, stopOnLast = stopOnLast})
			:give(C.anim_callback, { onComplete = function()
					if onComplete then
						onComplete(e)
					end
				end
			})
			:apply()

		self:changePalette(current_pal)
	end
end

function CustomizeCat:changePalette(new_pal)
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

function CustomizeCat:keypressed(key)
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

function CustomizeCat:update(dt)
	for _,e in ipairs(self.pool) do
		local c_collider = e[C.colliderBox]
		local c_state = e[C.state]
		if c_collider.isColliding and not c_state.isClicked and love.mouse.isDown(1) then
			c_state.isClicked = true
			self:onClick(e)
		end
		if not c_state.isHovered then
			c_state.isClicked = false
		end
	end
end

function CustomizeCat:onClick(e)
	if e:has(C.cat) then
		if e[C.fsm].current_state == "hurt" then
		elseif e[C.fsm].current_state == "spin" then
		else
			self:changeState("heart")
		end
	end
end

function CustomizeCat:onEnter(e)
	if e:has(C.cat) then
		if e[C.fsm].current_state == "heart" then
		elseif e[C.fsm].current_state == "hurt" then
		elseif e[C.fsm].current_state == "spin" then
		elseif e[C.fsm].current_state == "snore" then
		else
			self:changeState("blink")
		end
	end
end

function CustomizeCat:onExit(e)
	if e:has(C.cat) then
		if e[C.fsm].current_state == "heart" then
		elseif e[C.fsm].current_state == "hurt" then
		elseif e[C.fsm].current_state == "spin" then
		elseif e[C.fsm].current_state == "snore" then
		else
			self:changeState("mouth")
		end
	end
end

return CustomizeCat
