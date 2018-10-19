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
		else
			log.trace("GUI Normal Sprite Does Not Exist!")
		end
		if args.text then
			assert(args.font, "Font does not exist!")
			local pos = e[C.pos].pos:clone()
			local c_transform = e[C.transform]
			local sx, sy
			if c_transform then sx = c_transform.sx sy = c_transform.sy end
			local text = Entity()
				:give(C.text, args.text, args.font, "center", args.normal:getWidth() * (sx or 1))
				:give(C.color, args.textColor)
				:give(C.pos, pos)
				:give(C.offsetPos, vec2(-args.normal:getWidth()/2 * (sx or 1), 0))
				:give(C.parent, e)
				:apply()
			self:getInstance():addEntity(text)
			self.text[c_button.id] = text
		end
	end
	e:give(C.colliderSprite, { "point" })
		:give(C.state)
		:apply()
	if c_button.args and c_button.args.disabled then
		e[C.state].isDisabled = true
	end
	log.trace(("GUI ADDED: %s"):format(c_button.id))
end

function GUI:update(dt)
	for _,e in ipairs(self.pool) do
		local c_collider
		local c_button = e[C.button]
		local c_state = e[C.state]
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		if e:has(C.colliderSprite) then c_collider = e[C.colliderSprite] end
		if not c_state.isHovered then
			c_state.isClicked = false
		end
	end
end

function GUI:onClick()
	for _,e in ipairs(self.pool) do
		local c_button = e[C.button]
		local c_windowIndex = e[C.windowIndex]
		local c_state = e[C.state]
		if c_state.isDisabled then

		else
			if c_windowIndex then
				if not (c_windowIndex.index == __window) then
					return
				end
			end

			if c_state.isHovered and not c_state.isClicked and love.mouse.isDown(1) then
				c_state.isClicked = true
				log.trace(("GUI Button '%s' clicked!"):format(c_button.id))
				if c_button.args and c_button.args.onClick then
					c_button.args.onClick(self)
				end
			end
		end
	end
end

function GUI:onEnter(e)
	local c_state = e[C.state]
	if c_state.isDisabled then return end
	local c_button = e[C.button]
	local c_transform = e[C.transform]
	if not c_button then return end
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
	local c_state = e[C.state]
	if c_state.isDisabled then return end
	local c_button = e[C.button]
	local c_transform = e[C.transform]
	if not c_button then return end
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
