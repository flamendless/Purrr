local System = require("modules.concord.lib.system")
local C = require("ecs.components")

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
	})

function Renderer:entityAddedTo(e, pool)
	if pool.name == "patch" then
		local c_patch = e[C.patch]
		c_patch.patchy = patchy.load(c_patch.image)
	end
end

function Renderer:drawText()
	for _,e in ipairs(self.text) do
		local c_text = e[C.text]
		local c_pad = e[C.textPad]
		local c_pos = e[C.pos].pos
		local c_offset = e[C.offsetPos]
		local c_color = e[C.color].color
		local c_hoveredColor = e[C.hoveredColor]
		if c_color then
			if c_color.set then c_color:set()
			else love.graphics.setColor(c_color) end
		end
		if c_hoveredColor then c_hoveredColor.color:set() end
		if c_text.font then love.graphics.setFont(c_text.font) end
		local x = c_pos.x
		local y = c_pos.y
		local limit
		if c_text.font then
			y = y - c_text.font:getHeight("")/2
		end
		if c_offset then
			c_offset = e[C.offsetPos].offset
			x = x + c_offset.x
			y = y + c_offset.y
		end
		if c_pad then
			x = x + c_pad.pad.x
			y = y + c_pad.pad.y
		end
		if c_text.align then
			limit = c_text.limit
			if c_pad then
				limit = c_text.limit - c_pad.pad.x * 2
			end
			love.graphics.printf(c_text.text, x, y, limit, c_text.align)
		else
			love.graphics.print(c_text.text, x, y)
		end
	end
end

function Renderer:drawSprite()
	for _,e in ipairs(self.sprite) do
		local c_sprite = e[C.sprite]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color]
		local c_transform = e[C.transform]
		local c_state = e[C.state]
		local c_hoveredSprite = e[C.hoveredSprite]
		local sprite = c_sprite.sprite
		if c_hoveredSprite then
			sprite = c_hoveredSprite.sprite
		end
		if c_color then
			if c_color.color.set then c_color.color:set()
			else love.graphics.setColor(c_color.color)
			end
		end
		if c_state then
			if c_state.isDisabled then
				love.graphics.setColor(0, 0, 0, 0.25)
			end
		end
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
		if c_color then
			if c_color.set then c_color:set()
			else love.graphics.setColor(c_color)
			end
		end
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
		if c_color then
			if c_color.set then c_color:set()
			else love.graphics.setColor(c_color)
			end
		end
		love.graphics.circle(c_circle.mode, c_pos.x, c_pos.y, c_circle.radius, c_circle.segments)
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

return Renderer
