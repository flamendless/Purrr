local Utils = {}

local C = require("ecs.components")

function Utils:checkOnMouseEnter(e)
	local mx, my = love.mouse.getPosition()
	local c_collider_sprite = e[C.collider_sprite]
	local c_transform = e[C.transform]
	local c_sprite = e[C.sprite].sprite
	local x = c_transform.pos.x - c_transform.ox * c_transform.sx
	local y = c_transform.pos.y - c_transform.oy * c_transform.sy
	local w = c_sprite:getWidth() * c_transform.sx
	local h = c_sprite:getHeight() * c_transform.sy
	return mx > x and mx < x + w and my > y and my < y + h
end


return Utils
