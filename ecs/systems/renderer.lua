local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local Sprite = System({
		C.sprite,
		C.transform,
	})
local Animation = System({
		C.animation,
		C.transform,
	})

function Sprite:draw()
	for _, e in ipairs(self.pool) do
		if e:has(C.color) then
			love.graphics.setColor(e[C.color].color)
		end
		local c_sprite = e[C.sprite]
		local c_transform = e[C.transform]
		love.graphics.draw(c_sprite.sprite, c_transform.pos.x, c_transform.pos.y, c_transform.rotation, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy, c_transform.kx, c_transform.ky)
	end
end

function Animation:draw()
	for _, e in ipairs(self.pool) do
		local c_animation = e[C.animation].obj
		local c_transform = e[C.transform]
		local c_shaders = e[C.shaders]
		if e:has(C.color) then love.graphics.setColor(e[C.color].color) end
		if c_shaders then love.graphics.setShader(c_shaders.shaders) end
		c_animation:draw(c_transform.pos.x, c_transform.pos.y, c_transform.rotation, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy, c_transform.kx, c_transform.ky)
		if c_shaders then love.graphics.setShader() end
	end
end

return {
	sprite = Sprite,
	animation = Animation,
}
