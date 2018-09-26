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
		C.square,
		"square"
	})

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
	local e
	for i = 1, self.sprite.size do
		e = self.sprite:get(i)
		local c_sprite = e[C.sprite]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color].color
		local c_transform = e[C.transform]
		if c_color then c_color:set() end
		if c_transform then
			love.graphics.draw(c_sprite.sprite, c_pos.x, c_pos.y, c_transform.rot, c_transform.sx, c_transform.sy, c_transform.ox, c_transform.oy)
		else
			love.graphics.draw(c_sprite.sprite, c_pos.x, c_pos.y)
		end
	end
end

function Renderer:drawSquare()
	local e
	for i = 1, self.square.size do
		e = self.square:get(i)
		local c_square = e[C.square]
		local c_cornerRadius = e[C.cornerRadius]
		local c_pos = e[C.pos].pos
		local c_color = e[C.color]
		if c_color then c_color.color:set() end
		if c_square.size.x > 0 then
			love.graphics.rectangle(c_square.mode, c_pos.x, c_pos.y, c_square.size.x, c_square.size.y, (c_cornerRadius and c_cornerRadius.size) or 0)
		end
	end
end

return Renderer
