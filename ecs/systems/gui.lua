local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local GUI = System({
		C.button,
		C.pos,
	})

function GUI:entityAdded(e)
	local c_button = e[C.button]
	if c_button.args then
		local args = c_button.args
		if args.normal then
			e:give(C.sprite, args.normal):apply()
		end
		if args.hovered then
			e:give(C.hoveredSprite, args.hovered):apply()
		end
	end
	e:give(C.colliderBox, { "point" }):apply()
end

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
