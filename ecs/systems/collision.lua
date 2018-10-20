local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local log = require("modules.log.log")
local debugging = require("src.debug")

local Collision = System({
		C.colliderSprite,
		C.pos,
		C.sprite,
		"sprite"
	}, {
		C.colliderBox,
		C.pos,
		"box"
	})

function Collision:init()
	self.entities = {}
end

function Collision:entityAddedTo(e, pool)
	if pool.name == "sprite" then
		local c_colliderSprite = e[C.colliderSprite]
		local c_sprite = e[C.sprite]
		local c_pos = e[C.pos].pos
		local x = c_pos.x
		local y = c_pos.y
		local w = c_sprite.sprite:getWidth()
		local h = c_sprite.sprite:getHeight()
		local c_transform = e[C.transform]

		if c_transform then
			if c_transform.orig_ox == "center" then
				x = x - w/2
			elseif c_transform.orig_ox == "right" then
				x = x - w
			end
			if c_transform.orig_oy == "center" then
				y = y - h/2
			end
		end
		c_colliderSprite.pos = vec2(x, y)
		c_colliderSprite.size = vec2(w, h)
		if c_colliderSprite.canCollideWith then
			for i = 1, #c_colliderSprite.canCollideWith do
				local tag = c_colliderSprite.canCollideWith[i]
				if not self.entities[tag] then self.entities[tag] = {} end
				table.insert(self.entities[tag], e)
			end
		end

	elseif pool.name == "box" then
		local c_colliderBox = e[C.colliderBox]
		local c_pos = e[C.pos].pos
		local x = c_pos.x
		local y = c_pos.y
		local w = c_colliderBox.size.x
		local h = c_colliderBox.size.y
		local c_transform = e[C.transform]

		if c_transform then
			if c_transform.orig_ox == "center" then
				x = x - w/2
			end
			if c_transform.orig_oy == "center" then
				y = y - h/2
			end
		end

		c_colliderBox.pos = vec2(x, y)
		c_colliderBox.size = vec2(w, h)

		if c_colliderBox.canCollideWith then
			for i = 1, #c_colliderBox.canCollideWith do
				local tag = c_colliderBox.canCollideWith[i]
				if not self.entities[tag] then self.entities[tag] = {} end
				table.insert(self.entities[tag], e)
			end
		end
	end
end

function Collision:updatePosition()
	for _,e in ipairs(self.sprite) do
		local c_colliderSprite = e[C.colliderSprite]
		local c_pos = e[C.pos].pos
		local c_sprite = e[C.sprite].sprite
		local c_transform = e[C.transform]

		local sx = 1
		local sy = 1
		if c_transform then
			sx = c_transform.sx
			sy = c_transform.sy
		end
		local x = c_pos.x
		local y = c_pos.y
		local w = c_sprite:getWidth() * sx
		local h = c_sprite:getHeight() * sy
		if c_transform then
			if c_transform.orig_ox == "center" then
				x = x - w/2
			elseif c_transform.orig_ox == "right" then
				x = x - w
			end
			if c_transform.orig_oy == "center" then
				y = y - h/2
			end
		end
		c_colliderSprite.pos = vec2(x, y)
	end

	for _,e in ipairs(self.box) do
		local c_colliderBox = e[C.colliderBox]
		local c_pos = e[C.pos].pos
		local c_transform = e[C.transform]

		local x = c_pos.x
		local y = c_pos.y
		local w = c_colliderBox.size.x
		local h = c_colliderBox.size.y
		if c_transform then
			if c_transform.orig_ox == "center" then
				x = x - w/2
			elseif c_transform.orig_ox == "right" then
				x = x - w
			end
			if c_transform.orig_oy == "center" then
				y = y - h/2
			end
		end
		c_colliderBox.pos = vec2(x, y)
	end
end

function Collision:updateSize()
	for _,e in ipairs(self.sprite) do
		local c_colliderSprite = e[C.colliderSprite]
		local c_sprite = e[C.sprite].sprite
		local c_transform = e[C.transform]
		local sx = 1
		local sy = 1
		if c_transform then
			sx = c_transform.sx
			sy = c_transform.sy
		end
		local w = c_sprite:getWidth() * sx
		local h = c_sprite:getHeight() * sy
		c_colliderSprite.size = vec2(w, h)
	end
end

function Collision:checkPoint(dt)
	if not self.entities.point then return end
	for _,e in ipairs(self.entities.point) do
		local c_collider
		if e:has(C.colliderSprite) then c_collider = e[C.colliderSprite] end
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		if c_collider then
			local x,y = c_collider.pos:unpack()
			local w,h = c_collider.size:unpack()
			local mx, my = love.mouse.getPosition()
			local c_tag = e[C.tag]
			local c_button = e[C.button]
			local c_state = e[C.state]

			if (love.system.getOS() == "Android") then
				local touches = love.touch.getTouches()
				for i, id in ipairs(touches) do
					local mx, my = love.touch.getPosition(id)
					mx = mx/__scale
					my = my/__scale
					if mx >= x and mx <= x + w and my >= y and my <= y + h then
						if not c_collider.isColliding then
							self:getInstance():emit("onEnter", e)
							if c_state then c_state.isHovered = true end
							if c_tag then log.trace("Point onEnter: " .. c_tag.tag) end
							-- if c_button then log.trace("Point onEnter: " .. c_button.id) end
						end
						c_collider.isColliding = true
					else
						if c_collider.isColliding then
							self:getInstance():emit("onExit", e)
							if c_state then c_state.isHovered = false end
							if c_tag then log.trace("Point onExit: " .. c_tag.tag) end
							-- if c_button then log.trace("Point onExit: " .. c_button.id) end
						end
						c_collider.isColliding = false
					end
				end
			else
				if mx >= x and mx <= x + w and my >= y and my <= y + h then
					if not c_collider.isColliding then
						self:getInstance():emit("onEnter", e)
						if c_state then c_state.isHovered = true end
						-- if c_tag then log.trace("Point onEnter: " .. c_tag.tag) end
						-- if c_button then log.trace("Point onEnter: " .. c_button.id) end
					end
					c_collider.isColliding = true
				else
					if c_collider.isColliding then
						self:getInstance():emit("onExit", e)
						if c_state then c_state.isHovered = false end
						-- if c_tag then log.trace("Point onExit: " .. c_tag.tag) end
						-- if c_button then log.trace("Point onExit: " .. c_button.id) end
					end
					c_collider.isColliding = false
				end
			end
		end
	end
end

function Collision:draw()
	if not debugging.modes.collisions then return end
	for _,e in ipairs(self.sprite) do
		local c_collider = e[C.colliderSprite]
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line", c_collider.pos.x, c_collider.pos.y, c_collider.size.x, c_collider.size.y)
	end

	for _,e in ipairs(self.box) do
		local c_collider = e[C.colliderBox]
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line", c_collider.pos.x, c_collider.pos.y, c_collider.size.x, c_collider.size.y)
	end
end

return Collision
