local Utils = {}

local C = require("ecs.components")

function Utils:pointToRectCheck(px, py, x, y, w, h)
	return px > x and px < x + w and py > y and py < y + h
end

function Utils:checkOnMouseEnter(e)
	local mx, my = love.mouse.getPosition()
	local c_transform = e[C.transform]
	local x, y, w, h
	x = c_transform.pos.x - c_transform.ox * c_transform.sx
	y = c_transform.pos.y - c_transform.oy * c_transform.sy
	if e:has(C.collider_sprite) then
		local c_collider_sprite = e[C.collider_sprite]
		local c_sprite = e[C.sprite].sprite
		w = c_sprite:getWidth() * c_transform.sx
		h = c_sprite:getHeight() * c_transform.sy
		return self:pointToRectCheck(mx, my, x, y, w, h)
	elseif e:has(C.collider_rect) then
		local c_collider_rect = e[C.collider_rect]
		w = c_collider_rect.size.x
		h = c_collider_rect.size.y
		return self:pointToRectCheck(mx, my, x, y, w, h)
	end
	return false
end


return Utils
