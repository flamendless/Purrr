local BaseState = require("states.base_state")
local Map = BaseState("Map")

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local E = require("ecs.entities")
local C = require("ecs.components")
local S = require("ecs.systems")
local vec2 = require("modules.hump.vector")
local flux = require("modules.flux.flux")
local timer = require("modules.hump.timer")

local colors = require("src.colors")
local data = require("src.data")
local screen = require("src.screen")
local resourceManager = require("src.resource_manager")
local transition = require("src.transition")
local gamestate = require("src.gamestate")
local soundManager = require("src.sound_manager")
local event = require("src.event")
local assets = require("src.assets")

local max_view = 4
local current_view = 1

function Map:enter(previous, ...)
	self.images = resourceManager:getAll("images")
	self.fonts = resourceManager:getAll("fonts")
	self.instance = ecs.instance()
	self:setupSystems()
	self:setupEntities()
	self:start()
end

function Map:setupSystems()
	self.systems = {
		collision = S.collision(),
		gui = S.gui(),
		position = S.position(),
		renderer = S.renderer(),
		transform = S.transform(),
		animation = S.animation(),
		cat_fsm = S.cat_fsm("map"),
		moveTo = S.moveTo(),
		patrol = S.patrol(),
		follow = S.follow(),
	}

	self.instance:addSystem(self.systems.moveTo)
	self.instance:addSystem(self.systems.moveTo, "update")
	self.instance:addSystem(self.systems.patrol)
	self.instance:addSystem(self.systems.patrol, "startPatrol")
	self.instance:addSystem(self.systems.cat_fsm, "changeState")
	self.instance:addSystem(self.systems.cat_fsm, "overrideState")
	self.instance:addSystem(self.systems.cat_fsm, "changePalette")
	self.instance:addSystem(self.systems.cat_fsm, "update")
	self.instance:addSystem(self.systems.cat_fsm, "onEnter")
	self.instance:addSystem(self.systems.cat_fsm, "onExit")
	self.instance:addSystem(self.systems.position, "update")
	self.instance:addSystem(self.systems.collision)
	self.instance:addSystem(self.systems.collision, "update", "updatePosition")
	self.instance:addSystem(self.systems.collision, "update", "updateSize")
	self.instance:addSystem(self.systems.collision, "update", "checkPoint", false)
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.transform, "handleSprite")
	self.instance:addSystem(self.systems.transform, "handleAnim")
	self.instance:addSystem(self.systems.transform, "changeScale")
	self.instance:addSystem(self.systems.gui, "update")
	self.instance:addSystem(self.systems.gui, "update", "onClick")
	self.instance:addSystem(self.systems.gui, "onEnter")
	self.instance:addSystem(self.systems.gui, "onExit")
	self.instance:addSystem(self.systems.renderer, "draw", "drawSprite")
	self.instance:addSystem(self.systems.renderer, "draw", "drawText")
	self.instance:addSystem(self.systems.collision, "draw", "draw")
	self.instance:addSystem(self.systems.animation, "update")
	self.instance:addSystem(self.systems.animation, "draw")
	self.instance:addSystem(self.systems.follow, "update")
	self.instance:addSystem(self.systems.position, "update")
end

function Map:setupEntities()
	local current_world = data.data.world
	local current_level = data.data.level
	local img_map = self.images["map_" .. current_world]
	local sx = screen.x/img_map:getWidth()
	local sy = screen.y/img_map:getHeight()
	if current_world == "mars" then current_view = 1
	elseif current_world == "underground" then current_view = 2
	elseif current_world == "space" then current_view = 3
	elseif current_world == "earth" then current_view = 4
	end

	self.entities = {}
	self.entities.map = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2())
		:give(C.sprite, img_map)
		:give(C.transform, 0, sx, sy)
		:apply()

	local pos = {
		vec2(screen.x * 0.6, screen.y * 0.25),
		vec2(screen.x * 0.35, screen.y * 0.4),
		vec2(screen.x * 0.25, screen.y * 0.55),
		vec2(screen.x * 0.75, screen.y * 0.65),
		vec2(screen.x * 0.5, screen.y * 0.85)
	}
	for i = 1, 5 do
		local img_level, img_level_hovered
		if i == current_level then
			img_level = self.images.level_current
			img_level_hovered = self.images.level_current_hovered
		elseif i < current_level then
			img_level = self.images.level_complete
			-- img_level_hovered = self.images.level_complete_hovered
		elseif i > current_level then
			img_level = self.images.level_not
			-- img_level_hovered = self.images.level_not_hovered
		end
		self.entities["level" .. i] = ecs.entity()
			:give(C.color, colors("white"))
			:give(C.pos, pos[i])
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.maxScale, 2.5, 2.5)
			:give(C.button, "level" .. i, {
					normal = img_level,
					hovered = img_level_hovered,
					text = tostring(i),
					font = self.fonts.level_32,
					textColor = colors("white"),
				})
			:apply()

			if i == current_level then
				self.entities["level" .. i]
					:give(C.onClick, function(e)
							self:onClick("level" .. i)
						end)
					:apply()
			else
				self.entities["level" .. i]
					:give(C.onClick, function(e)
						soundManager:send("lock")
					end)
			end
	end

	local img_display
	if current_world == "underground" then img_display = self.images.display_caverns
	else img_display = self.images["display_" .. current_world]
	end
	self.entities.display = ecs.entity()
		:give(C.color, colors("white"))
		:give(C.pos, vec2(screen.x/2, 8))
		:give(C.transform, 0, 1, 1, "center")
		:give(C.sprite, img_display)
		:apply()

	if current_view < max_view then
		self.entities.forward = ecs.entity()
			:give(C.color, colors("white"))
			:give(C.button, "forward", {
					normal = self.images.btn_forward,
					hovered = self.images.btn_forward_hovered,
					onClick = function(system)
						self:forward()
						soundManager:send("page_turn")
					end
				})
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.pos, vec2(screen.x * 0.82, screen.y * 1.5))
			:give(C.maxScale, 2.5, 2.5)
			:apply()
	end

	if current_view > 1 then
		self.entities.back = ecs.entity()
			:give(C.color, colors("white"))
			:give(C.button, "back", {
					normal = self.images.btn_back,
					hovered = self.images.btn_back_hovered,
					onClick = function(system)
						self:back()
						soundManager:send("page_turn")
					end
				})
			:give(C.transform, 0, 2, 2, "center", "center")
			:give(C.maxScale, 2.5, 2.5)
			:give(C.pos, vec2(screen.x * 0.18, screen.y * 1.5))
			:apply()
	end

	if data.data.locked[current_world] then
		self.entities.lock = ecs.entity()
			:give(C.color, colors("white"))
			:give(C.pos, vec2(screen.x/2, screen.y/2))
			:give(C.sprite, self.images.lock)
			:give(C.transform, 0, 5, 5, "center", "center")
			:apply()
	end

	local cat_pos = pos[current_level]
	self.entities.cat = ecs.entity()
		:give(C.tag, "cat")
		:give(C.cat)
		:give(C.fsm, "random", { "attack", "blink", "dizzy", "hurt", "heart", "mouth", "sleep", "snore", "spin"})
		:give(C.color, colors("white"))
		:give(C.pos, vec2(cat_pos.x, cat_pos.y - 64))
		:give(C.transform, 0, 1, 1, "center", "center")
		:apply()

	self.entities.home = E.lobby_buttons(ecs.entity(), "home", "home")
		:remove(C.pos):remove(C.transform):apply()
		:give(C.pos, vec2( 16, 16 ))
		:give(C.transform, 0, 2, 2)
		:give(C.onClick, function(e) event:showHomeConfirmation("lobby") end)
		:apply()

	self.instance:addEntity(self.entities.map)
	self.instance:addEntity(self.entities.display)
	self.instance:addEntity(self.entities.home)
	if self.entities.lock then self.instance:addEntity(self.entities.lock)
	else
		self.instance:addEntity(self.entities.level1)
		self.instance:addEntity(self.entities.level2)
		self.instance:addEntity(self.entities.level3)
		self.instance:addEntity(self.entities.level4)
		self.instance:addEntity(self.entities.level5)
		self.instance:addEntity(self.entities.cat)
	end
	if self.entities.forward then self.instance:addEntity(self.entities.forward) end
	if self.entities.back then self.instance:addEntity(self.entities.back) end
end

function Map:start()
	local dur = 1
	if self.entities.back then flux.to(self.entities.back[C.pos].pos, dur, { y = screen.y * 0.9 }):ease("backout") end
	if self.entities.forward then flux.to(self.entities.forward[C.pos].pos, dur, { y = screen.y * 0.9 }):ease("backout") end
	timer.after(dur, function()
		self.instance:enableSystem(self.systems.collision, "update", "checkPoint")
	end)
end

function Map:update(dt)
	self.instance:emit("update", dt)
end

function Map:draw()
	self.instance:emit("draw")
	if not (__window == 1) then
		event:drawCover()
	end
end

function Map:forward()
	transition:start(function()
		if data.data.world == "mars" then data.data.world = "underground"
		elseif data.data.world == "underground" then data.data.world = "space"
		elseif data.data.world == "space" then data.data.world = "earth"
		end
		current_view = current_view + 1
		gamestate:switch(self)
	end)
end

function Map:back()
	transition:start(function()
		if data.data.world == "earth" then data.data.world = "space"
		elseif data.data.world == "space" then data.data.world = "underground"
		elseif data.data.world == "underground" then data.data.world = "mars"
		end
		current_view = current_view - 1
		gamestate:switch(self)
	end)
end

function Map:onClick(msg)
	event:showLock("It's unavailable for now. The developer will update content as soon as possible. For now just enjoy the cuteness.")
end

function Map:keypressed(key)
	if key == "escape" then
		transition:start(require("states.lobby"))
	end
end

function Map:exit()
	if self.instance then self.instance:clear() end
end

return Map
