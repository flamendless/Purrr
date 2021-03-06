local System = require("modules.concord.lib.system")
local Entity = require("modules.concord.lib.entity")
local C = require("ecs.components")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local touch = require("src.touch")
local debugging = require("src.debug")

local GUI = System({
		C.button,
		C.pos,
	})

local checkIfClicked, checkForWindow

function GUI:init()
	self.text = {}
end

function GUI:entityAdded(e)
	local c_button = e[C.button]
	if c_button.args then
		local args = c_button.args
		if args.onClick and e:has(C.onClick) then
			error(("%s button has two onClick events! Check the entity's button and onClick components!"):format(c_button.id))
		end
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
		if e:has(C.onUpdate) then
			e[C.onUpdate].onUpdate(e)
		end
		if e:has(C.colliderBox) then c_collider = e[C.colliderBox] end
		if e:has(C.colliderSprite) then c_collider = e[C.colliderSprite] end
		if not c_state.isHovered then
			c_state.isClicked = false
		end
		if love.system.getOS() == "Android" then
			if not touch:getTouch() then
				c_state.isClicked = false
			end
		end
	end
end

function GUI:mousepressed(mx, my, mb)
	for _, e in ipairs(self.pool) do
		local c_button = e[C.button]
		local c_state = e[C.state]
		if c_state.isDisabled then
			log.warn(("Clicked on: %s which is disabled"):format(c_button.id))
		else
			if c_state.isHovered and not c_state.isClicked then
				local bool = checkIfClicked(mb)
				local safe = checkForWindow(e)
				if bool and safe then
					c_state.isClicked = true
					if e:has(C.onClick) then
						e[C.onClick].onClick(self, e)
						log.trace(("GUI Button '%s' clicked!"):format(c_button.id))
					else
						if c_button.args and c_button.args.onClick then
							c_button.args.onClick(self, e)
							log.trace(("GUI Button '%s' clicked!"):format(c_button.id))
						end
					end
				end
				if __debug and mb == 2 then
					debugging:onEntitySelect(e)
				end
			end
		end
	end
end

function GUI:changeSprite(e, spr, hovered_spr)
	local c_button = e[C.button]
	c_button.args.normal = spr
	c_button.args.hovered = hovered_spr
	e:remove(C.sprite):remove(C.hoveredSprite):apply()
	e:give(C.sprite, spr):give(C.hoveredSprite, hovered_spr):apply()
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
		if e:has(C.onHover) then
			e[C.onHover].onHover(e)
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
	if e:has(C.onExit) then
		e[C.onExit].onExit(e)
	end
end

function checkIfClicked(mb)
	local bool
	if love.system.getOS() == "Android" then
		bool = touch:getTouch()
	else
		bool = mb == 1
	end
	return bool
end

function checkForWindow(e)
	local c_windowIndex = e[C.windowIndex]
	local c_windowButton = e[C.windowButton]
	if c_windowIndex then
		return c_windowIndex.index == __window
	end
	if c_windowButton then
		return c_windowButton.index == __window
	end
end

return GUI
