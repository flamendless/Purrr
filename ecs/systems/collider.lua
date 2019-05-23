local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local utils = require("src.utils")

local debugger = require("src.debug")
local vec2 = require("modules.hump.vector")

local Collider = System({
		C.collider_rect,
		C.transform,
		"rect"
	}, {
		C.collider_sprite,
		C.sprite,
		C.transform,
		"sprite"
	})

function Collider:draw()
	for _, e in ipairs(self.sprite) do
		local c_collider_sprite = e[C.collider_sprite]
		local c_transform = e[C.transform]
		local c_sprite = e[C.sprite].sprite
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line",
			c_transform.pos.x - c_transform.ox * c_transform.sx,
			c_transform.pos.y - c_transform.oy * c_transform.sy,
			c_sprite:getWidth() * c_transform.sx,
			c_sprite:getHeight() * c_transform.sy)
	end

	for _, e in ipairs(self.rect) do
		local c_collider_rect = e[C.collider_rect]
		local c_transform = e[C.transform]
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line",
			c_transform.pos.x - c_transform.ox * c_transform.sx,
			c_transform.pos.y - c_transform.oy * c_transform.sy,
			c_collider_rect.size.x * c_transform.sx,
			c_collider_rect.size.y * c_transform.sy)
	end
end

function Collider:mousepressed(mx, my, mb)
	for _, e in ipairs(self.sprite) do
		local onMouseEnter = utils:checkOnMouseEnter(e)
		if onMouseEnter then
			if mb == 2 and __debug then
				debugger:onEntitySelect(e)
			end
		end
	end

	for _, e in ipairs(self.rect) do
		local onMouseEnter = utils:checkOnMouseEnter(e)
		if onMouseEnter then
			if mb == 2 and __debug then
				debugger:onEntitySelect(e)
			end
		end
	end
end

--TODO: add touchpressed

return Collider
