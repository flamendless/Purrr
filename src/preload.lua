local Preload = {}

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
local S = require("ecs.systems")
local C = require("ecs.components")

local lily = require("modules.lily.lily")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local Draft = require("modules.draft.draft")
local draft = Draft()

local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local colors = require("src.colors")

function Preload:init()
	self.colors = {
		bg = colors("flat", "black", "dark"),
		text = colors("flat", "white", "dark"),
		circle = colors("flat", "red", "dark"),
		rect = colors("flat", "blue", "dark"),
		triangle = colors("flat", "green", "dark"),
	}

	self.font = love.graphics.newFont("assets/fonts/vera.ttf", 24)
	self.toLoad = {}
	self.userdata = {}
	self.n = 0
	self.isActive = false
	self.percent = 0
	self:set()
end

function Preload:check(t_assets)
	for kind, t in pairs(t_assets) do
		for i, v in pairs(t) do
			if not resourceManager:check(kind, v.id) then
				self:add(kind, v)
			end
		end
	end
	if self.n > 0 then
		self:start()
	end
end

function Preload:add(kind, data)
	if kind == "images" then
		self.toLoad[self.n] = { "newImage", data.path }
		self.userdata[self.n] = data.id
		self.n = self.n + 1
	elseif kind == "fonts" then
		if #data.sizes > 1 then
			for i = 1, #data.sizes do
				self.toLoad[self.n] = { "newFont", data.path, data.sizes[i] }
				self.userdata[self.n] = data.id .. "_" .. data.sizes[i]
				self.n = self.n + 1
			end
		else
			self.toLoad[self.n] = { "newFont", data.path, data.sizes[1] }
			self.userdata[self.n] = data.id .. "_" .. data.sizes[1]
			self.n = self.n + 1
		end
	end
end

function Preload:start()
	self:addAnimation()
	self.preloaderDone = false
	self.isActive = true
	self.lily = lily.loadMulti(self.toLoad)
		:setUserData(self.userdata)
		:onLoaded(function(id, i, data)
			if id then
				local kind = string.lower(data:type() .. "s")
				if data.setFilter then
					data:setFilter(__filter, __filter)
				end
				log.trace(("Loaded: %s - %s"):format(kind, id[i]))
				resourceManager:add(kind, id[i], data)
			end
		end)
		:onComplete(function()
			self:complete()
		end)
end

function Preload:update(dt)
	if self.isActive then
		self.instance:emit("update", dt)
		if self.lily then
			local nLoaded = self.lily:getLoadedCount()
			local nTotal = self.lily:getCount()
			if nLoaded ~= 0 then
				self.percent = nLoaded/nTotal * 100
			end
		end
	end
end

function Preload:draw()
	if self.isActive then
		self.colors.bg:setBG()
		self.colors.text:set()
		love.graphics.setFont(self.font)
		-- love.graphics.printf(("LOADING %i%%"):format(self.percent), 0, screen.y/2 + 128, screen.x, "center")
		self.instance:emit("draw")
	end
end

function Preload:set()
	self.instance = ecs.instance()
	self.systems = {
		squareTransform = S.squareTransform(),
		shapeTransform = S.shapeTransform(),
		renderer = S.renderer(),
		changeColor = S.changeColor(),
		transform = S.transform(),
		spinner = S.spinner(),
	}

	self.entities = {}
	self.instance:addSystem(self.systems.transform)
	self.instance:addSystem(self.systems.changeColor, "change")
	self.instance:addSystem(self.systems.shapeTransform, "update")
	self.instance:addSystem(self.systems.shapeTransform, "draw")
	self.instance:addSystem(self.systems.spinner, "update")
	-- self.instance:addSystem(self.systems.squareTransform, "transformToNone", "transformToNone", false)
	self.instance:addSystem(self.systems.renderer, "draw", "drawPolygon")
	-- self.instance:addSystem(self.systems.renderer, "draw", "drawCircle", false)
	-- self.instance:addSystem(self.systems.renderer, "draw", "drawRect", false)
end

function Preload:addAnimation()
	-- local e = ecs.entity()
	-- 	:give(C.colors, { self.colors.circle, self.colors.rect, self.colors.triangle })
	-- 	:give(C.square, "fill", vec2(128, 128))
	-- 	:give(C.pos, vec2(screen.x/2, screen.y/2))
	-- 	:give(C.cornerRadius, 128)
	-- 	:give(C.transform, 0, 1, 1, "center", "center")
	-- 	:give(C.shapeTransform)
	-- 	:give(C.changeColor)
	-- 	:apply()

	local e = ecs.entity()
		:give(C.colors, { self.colors.circle, self.colors.rect, self.colors.triangle })
		:give(C.shapeTransform)
		:give(C.points, 1, unpack({
				[1] = draft:circle(0, 0, 256, 32, "line"),
				[2] = draft:circle(0, 0, 128, 16, "line"),
				[3] = draft:circle(0, 0, 64, 8, "line"),
			}))
		:give(C.transform, 0, 1, 1, "center", "center")
		:give(C.pos, vec2(screen.x/2, screen.y/2))
		:give(C.changeColor)
		:give(C.debug, __debug)
		:apply()

	self.entities.preloader = e
	self.instance:addEntity(e)
end

function Preload:complete()
	local dur = 2
	log.trace("ASSETS:")
	print(inspect(resourceManager.__assets))
	flux.to(self.colors.text, 1, { [4] = 0 })
	-- self.instance:emit("transformToNone", self.entities.preloader, dur)
	timer.after(dur, function()
		-- self.isActive = false
		self.percent = 0
		self.n = 0
		self.toLoad = {}
		self.userdata = {}
	end)
end

function Preload:getState() return self.isActive end

return Preload
