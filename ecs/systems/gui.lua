local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local GUI = System({
		C.button,
		C.pos,
		C.sprite,
	})

function GUI:update(dt)
	for _,e in ipairs(self.pool) do
		local c_collider
		local c_hoveredSprite = e[C.hoveredSprite]
		local c_button = e[C.button]
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		c_button.isHovered = c_collider.isColliding

		if c_hoveredSprite then
			c_hoveredSprite.state = c_button.isHovered
		end
	end
end

function GUI:onEnter(e)
end

function GUI:onExit(e)
end

return GUI
