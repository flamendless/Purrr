local System = require("modules.concord.lib.system")

local C = require("ecs.components")

local flux = require("modules.flux.flux")

local AlphaFade = System({
		C.color,
		C.alpha_fade,
		C.fade_state,
	})

function AlphaFade:entityAdded(e)
	local c_fade_state = e[C.fade_state]
	if c_fade_state.state == "out" then
		self:fadeOut(e)
	elseif c_fade_state.state == "in" then
		self:fadeIn(e)
	end
end

function AlphaFade:fadeIn(e)
	local c_color = e[C.color].color
	local c_fade_state = e[C.fade_state]
	local c_alpha_fade = e[C.alpha_fade].loop
	local duration = c_fade_state.duration
	flux.to(c_color, duration, { [4] = 1 })
		:oncomplete(function()
			e:remove(C.fade_state):apply()
			if c_alpha_fade then
				e:give(C.fade_state, "out", duration):apply()
			end
		end)
end

function AlphaFade:fadeOut(e)
	local c_color = e[C.color].color
	local c_fade_state = e[C.fade_state]
	local c_alpha_fade = e[C.alpha_fade].loop
	local duration = c_fade_state.duration
	flux.to(c_color, duration, { [4] = 0 })
		:oncomplete(function()
			e:remove(C.fade_state):apply()
			if c_alpha_fade then
				e:give(C.fade_state, "in", duration):apply()
			end
		end)
end

return AlphaFade
