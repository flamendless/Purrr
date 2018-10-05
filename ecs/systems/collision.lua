local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")

local Collision = System({
		C.colliderBox,
		C.pos,
		C.sprite,
		"box"
	})

function Collision:init()
	self.entities = {}
end

function Collision:entityAddedTo(e, pool)
	if pool.name == "box" then
		local c_colliderBox = e[C.colliderBox]
		local c_pos = e[C.pos].pos
		local c_sprite = e[C.sprite].sprite
		local c_transform = e[C.transform]

		local x = c_pos.x
		local y = c_pos.y
		local w = c_sprite:getWidth()
		local h = c_sprite:getHeight()
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

function Collision:checkPoint(dt)
	if not self.entities.point then return end
	for _,e in ipairs(self.entities.point) do
		local c_collider
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		local x,y = c_collider.pos:unpack()
		local w,h = c_collider.size:unpack()
		local mx, my = love.mouse.getPosition()
		if mx >= x and mx <= x + w and my >= y and my <= y + h then
			if not c_collider.isColliding then
				self:getInstance():emit("onEnter", e)
			end
			c_collider.isColliding = true
		else
			if c_collider.isColliding then
				self:getInstance():emit("onEnter", e)
			end
			c_collider.isColliding = false
		end
	end
end

return Collision
