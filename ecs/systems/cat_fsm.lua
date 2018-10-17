local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local resourceManager = require("src.resource_manager")

local CatFSM = System({
		C.fsm,
		C.cat,
	})

local data = {}
local shaders_palette

function CatFSM:init()
	shaders_palette = love.graphics.newShader("shaders/palette_swap.glsl")
	data.speed = {
		attack = 0.3, blink = 0.5, dizzy = 0.5, heart = 0.75,
		hurt = 0.4, sleep = 0.5, snore = 0.8, spin = 1
	}
	data.stopOnLast = { attack = true, hurt = true, sleep = true }
	data.onComplete = {}
	data.onComplete.sleep = function() self:changeState("snore") end
end

function CatFSM:entityAdded(e)
	local c_fsm = e[C.fsm]
	local state = c_fsm.current_state
	for k,v in ipairs(c_fsm.states) do c_fsm.states[v] = v end
	self:changeState(state)
end

function CatFSM:changeState(state)
	for _,e in ipairs(self.pool) do
		local c_fsm = e[C.fsm]
		if not (c_fsm.states[state]) then error("State does not exist!") end
		local sheet = resourceManager:getImage("sheet_cat_" .. state)
		local json = "assets/anim/json/cat_" .. state .. ".json"
		local pal = resourceManager:getImage("pal_" .. state .. "_source")
		local speed = data.speed[state]
		local stopOnLast = data.stopOnLast[state]
		local onComplete = data.onComplete[state]

		e:remove(C.anim):remove(C.shaders):remove(C.anim_callback):apply()
		e:give(C.anim, json, sheet, {speed = speed, stopOnLast = stopOnLast})
			:give(C.shaders, shaders_palette, "palette", pal)
			:give(C.anim_callback, { onComplete = onComplete })
			:apply()
	end
end

return CatFSM
