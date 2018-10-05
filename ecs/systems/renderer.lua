local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local patchy = require("modules.patchy.patchy")

local Renderer = System({
		C.sprite,
		C.pos,
		"sprite"
	}, {
		C.pos,
		C.text,
		"text"
	}, {
		C.pos,
		C.rect,
		"rect"
	}, {
		C.pos,
		C.circle,
		"circle"
	}, {
		C.points,
		"points",
	}, {
		C.pos,
		C.patch,
		"patch"
	})

function Renderer:entityAddedTo(e, pool)
	if pool.name == "patch" then
		local c_patch = e[C.patch]
		c_patch.patchy = patchy.load(c_patch.image)
	end
end

function Renderer:drawText()
	local e
	for i = 1, self.text.size do
		e = self.text:get(i)
		local c_text = e[C.text]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color].color
		if c_color then c_color:set() end
		if c_text.font then love.graphics.setFont(c_text.font) end
		if c_text.align then
			love.graphics.printf(c_text.text, c_pos.x, c_pos.y, c_text.limit, c_text.align)
		else
			love.graphics.print(c_text.text, c_pos.x, c_pos.y)
		end
	end
end

function Renderer:drawSprite()
	for _,e in ipairs(self.sprite) do
		local c_sprite = e[C.sprite]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color].color
		local c_transform = e[C.transform]
		local c_hoveredSprite = e[C.hoveredSprite]
		local sprite = c_sprite.sprite
		if c_hoveredSprite and c_hoveredSprite.state then
			sprite = c_hoveredSprite.sprite
		end
		if c_color then c_color:set() end
		if c_transform then
			love.graphics.draw(sprite, c_pos.x, c_pos.y, c_transform.rot, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy)
		else
			love.graphics.draw(sprite, c_pos.x, c_pos.y)
		end
	end
end

function Renderer:drawRect()
	local e
	for i = 1, self.rect.size do
		e = self.rect:get(i)
		local c_rect = e[C.rect]
		local c_cornerRadius = e[C.cornerRadius]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color]
		if c_color then c_color.color:set() end
		if c_rect.size.x > 0 then
			love.graphics.rectangle(c_rect.mode, c_pos.x, c_pos.y, c_rect.size.x, c_rect.size.y, (c_cornerRadius and c_cornerRadius.size) or 0)
		end
	end
end

function Renderer:drawCircle()
	local e
	for i = 1, self.circle.size do
		e = self.circle:get(i)
		local c_circle = e[C.circle]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color]
		if c_color then c_color.color:set() end
	end
end

function Renderer:drawPolygon()
	local e
	for i = 1, self.points.size do
		e = self.points:get(i)
		local c_points = e[C.points]
		local c_pos = e[C.pos]
		local c_transform = e[C.transform]
		local c_color = e[C.color]
		local c_fillMode = e[C.fillMode]
		if c_fillMode then c_fillMode = c_fillMode.mode end
		if c_color then c_color.color:set() end
		if c_transform then
			love.graphics.push()
			if c_pos then love.graphics.translate(c_pos.pos.x, c_pos.pos.y) end
			love.graphics.rotate(c_transform.rot)
		end
		love.graphics.polygon(c_fillMode or "line", c_points.points)
		if c_transform then love.graphics.pop() end
	end
end

function Renderer:draw9Patch()
	for _,e in ipairs(self.patch) do
		local c_pos = e[C.pos].pos
		local c_transform = e[C.transform]
		local c_patch = e[C.patch]
		local c_color = e[C.color]
		if c_color then c_color.color:set() end
		c_patch.patchy:draw(c_pos.x, c_pos.y, c_patch.size.x, c_patch.size.y)
	end
end

return Renderer
