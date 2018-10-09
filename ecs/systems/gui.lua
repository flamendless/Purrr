local System = require("modules.concord.lib.system")
local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")

local GUI = System({
		C.button,
		C.pos,
	})

function GUI:init()
	self.text = {}
end

function GUI:entityAdded(e)
	local c_button = e[C.button]
	if c_button.args then
		local args = c_button.args
		if args.normal then
			e:give(C.sprite, args.normal):apply()
		end
		if args.text then
			assert(args.font, "Font does not exist!")
			local text = Entity()
				:give(C.text, args.text, args.font, "center", args.normal:getWidth())
				:give(C.color, args.textColor)
				:give(C.pos, e[C.pos].pos:clone())
				:give(C.offsetPos, vec2(-args.normal:getWidth()/2, 0))
				:give(C.parent, e)
				:apply()
			self:getInstance():addEntity(text)
			self.text[c_button.id] = text
		end
	end
	e:give(C.colliderBox, { "point" }):apply()
	log.trace(("GUI ADDED: %s"):format(c_button.id))
end

function GUI:update(dt)
	for _,e in ipairs(self.pool) do
		local c_collider
		local c_button = e[C.button]
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		c_button.isHovered = c_collider.isColliding
	end
end

function GUI:onClick()
	for _,e in ipairs(self.pool) do
		local c_button = e[C.button]
		local c_windowIndex = e[C.windowIndex]
		if c_windowIndex then
			if not (c_windowIndex.index == __window) then
				return
			end
		end
		if c_button.isHovered and not c_button.isClicked and love.mouse.isDown(1) then
			c_button.isClicked = true
			if c_button.args and c_button.args.onClick then
				c_button.args.onClick()
			end
		end
	end
end

function GUI:onEnter(e)
	local c_button = e[C.button]
	local c_transform = e[C.transform]
	if c_button.args and c_button.args.hovered then
		e:give(C.hoveredSprite, c_button.args.hovered)
			:give(C.patrol, { vec2(0, -8), vec2(0, 8) }, true)
			:give(C.speed, vec2(0, 32))
			:apply()
		if self.text[c_button.id] then
			if c_button.args.hoveredTextColor then
				self.text[c_button.id]:give(C.hoveredColor, c_button.args.hoveredTextColor):apply()
			end
		end
		if c_transform then
			self:getInstance():emit("changeScale", e, c_transform.sx + 0.25, c_transform.sy + 0.25, 0.25)
		end
	end
end

function GUI:onExit(e)
	local c_button = e[C.button]
	local c_transform = e[C.transform]
	c_button.isClicked = false
	e:remove(C.hoveredSprite)
		:remove(C.patrol)
		:remove(C.speed)
		:apply()
	if self.text[c_button.id] then
		self.text[c_button.id]:remove(C.hoveredColor):apply()
	end
	if c_transform then
		self:getInstance():emit("changeScale", e, nil, nil, 0.25)
	end
end

return GUI
