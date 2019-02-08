local System = require("modules.concord.lib.system")
local C = require("ecs.components")

local screen = require("src.screen")

local Sprite = System({
		C.sprite,
		C.transform,
	})

local Animation = System({
		C.animation,
		C.transform,
	})

local BG = System({
		C.background,
	})

function Sprite:draw()
	for _, e in ipairs(self.pool) do
		if e:has(C.color) then
			love.graphics.setColor(e[C.color].color)
		end
		local c_sprite = e[C.sprite]
		local c_onHoveredSprite = e[C.onHoveredSprite]
		local c_transform = e[C.transform]
		local sprite
		if c_onHoveredSprite and c_onHoveredSprite.isActive then
			sprite = c_onHoveredSprite.sprite
		else
			sprite = c_sprite.sprite
		end
		love.graphics.draw(sprite, c_transform.pos.x, c_transform.pos.y, c_transform.rotation, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy, c_transform.kx, c_transform.ky)
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

function BG:draw()
	for _, e in ipairs(self.pool) do
		local c_bg = e[C.background].bg
		if e:has(C.color) then love.graphics.setColor(e[C.color].color) end
		love.graphics.draw(c_bg, 0, 0, 0, screen.x/c_bg:getWidth(), screen.y/c_bg:getHeight())
	end
end

return {
	sprite = Sprite,
	animation = Animation,
	bg = BG,
}
