local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local lume = require("modules.lume.lume")
local timer = require("modules.hump.timer")
local resourceManager = require("src.resource_manager")

local CatFSM = System({
		C.fsm,
		C.cat,
	})

local _states = {}
local _palettes = { "source", "softmilk" }
local current = 1
local cur_pal = 1
local current_pal
local data = {}
local shaders_palette

function CatFSM:init()
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
		timer.after(r, function() self:changeState(next_state) end)
	end
	data.onComplete.mouth = data.onComplete.blink
	data.onComplete.sleep = function() self:changeState("snore") end
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
end

function CatFSM:changeState(state)
	for _,e in ipairs(self.pool) do
		local c_fsm = e[C.fsm]
		if not (c_fsm.states[state]) then error("State does not exist!") end
		c_fsm.current_state = state
		local sheet = resourceManager:getImage("sheet_cat_" .. state)
		local json = "assets/anim/json/cat_" .. state .. ".json"
		local speed = data.speed[state]
		local stopOnLast = data.stopOnLast[state]
		-- local onComplete = data.onComplete[state]

		e:remove(C.anim):remove(C.anim_callback):apply()
		e:give(C.anim, json, sheet, {speed = speed, stopOnLast = stopOnLast})
			:give(C.anim_callback, { onComplete = onComplete })
			:apply()

		self:changePalette(current_pal)
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
			current = current + 1
			if current > #_states then current = 1 end
		elseif key == "down" then
			current = current - 1
			if current <= 0 then current = #_states end
		elseif key == "left" then
			cur_pal = cur_pal - 1
			if cur_pal <= 0 then cur_pal = #_palettes end
		elseif key == "right" then
			cur_pal = cur_pal + 1
			if cur_pal > #_palettes then cur_pal = 1 end
		end
		self:changePalette(_palettes[cur_pal])
		self:changeState(_states[current])
	end
end

return CatFSM
