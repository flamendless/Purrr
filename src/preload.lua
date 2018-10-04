local Preload = {}

local lily = require("modules.lily.lily")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")
local vec2 = require("modules.hump.vector")
local lume = require("modules.lume.lume")
local peachy = require("modules.peachy.peachy")

local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local colors = require("src.colors")

local dur = 2
if __debug then dur = 0 end

function Preload:init()
	self.colors = {
		bg = colors("flat", "black", "dark"),
		text = colors("flat", "white", "dark"),
	}
	local gamestate = require("src.gamestate")
	gamestate:addInstance("loading", require("ecs.instances.loading"))

	self.font = love.graphics.newFont("assets/fonts/vera.ttf", 24)
	self.toLoad = {}
	self.userdata = {}
	self.n = 0
	self.isActive = false
	self.percent = 0
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
		-- self.colors.text:set()
		-- love.graphics.setFont(self.font)
		-- love.graphics.printf(("LOADING %i%%"):format(self.percent), 0, screen.y/2 + 128, screen.x, "center")
	end
end

function Preload:complete()
	log.trace("ASSETS:")
	print(inspect(resourceManager.__assets))
	flux.to(self.colors.text, 1, { [4] = 0 })
	timer.after(dur, function()
		self.isActive = false
		self.percent = 0
		self.n = 0
		self.toLoad = {}
		self.userdata = {}
		local gamestate = require("src.gamestate")
		gamestate:removeInstance("loading")
	end)
end

function Preload:getState() return self.isActive end

return Preload
