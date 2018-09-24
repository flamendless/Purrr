local System = require("modules.concord.lib.system")
local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local timer = require("modules.hump.timer")
local vec2 = require("modules.hump.vector")
local lume = require("modules.lume.lume")
local flux = require("modules.flux.flux")

local colors = require("src.colors")
local screen = require("src.screen")

local GlitchEffect = System({
		C.glitch,
		C.transform,
		C.sprite,
	})

function GlitchEffect:entityAdded(e)
	local c_glitch = e[C.glitch]
	local c_sprite = e[C.sprite].sprite
	self.instance = self:getInstance()
	self.timer = timer()
	self.effect = timer()
	self.finish = timer()
	self.timer:every(1.5, function()
		local r = math.random(30, 70)/100
		self.effect:during(r, function()
			local c = lume.weightedchoice( { yes = 15, no = 85 } )
			if c == "yes" then
				local color = colors("random", 0.2)
				local scale = math.random(50, 175)/100
				local e = Entity()
					:give(C.color, color)
					:give(C.transform, 0, scale, scale, "center", "center")
					:give(C.sprite, c_sprite)
					:give(C.pos, vec2(math.random(0, screen.x), math.random(0, screen.y)))
					:apply()
				self.instance:addEntity(e)

				flux.to(color, 0.5, { [4] = 0 })
					:oncomplete(function()
						self.instance:removeEntity(e)
					end)
			end
		end)
	end)
	if c_glitch.dur > 0 then
		self.finish:after(c_glitch.dur, function()
			e:remove(C.glitch):apply()
		end)
	end
end

function GlitchEffect:update(dt)
	local e
	for i = 1, self.pool.size do
		self.timer:update(dt)
		self.effect:update(dt)
	end
end

return GlitchEffect
