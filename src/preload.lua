local Preload = {}

local lily = require("modules.lily.lily")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local gamestate = require("modules.hump.gamestate")
local timer = require("modules.hump.timer")

local resourceManager = require("src.resource_manager")
local screen = require("src.screen")
local colors = require("src.colors")
local loading_bar = require("src.loading_bar")

function Preload:init()
	self.colors = {
		bg = colors("flat", "black", "dark"),
		bar = colors("flat", "white", "light"),
	}
	self.toLoad = {}
	self.userdata = {}
	self.n = 0
	self.isActive = false
	self.done_count = 0
	self.current = gamestate.current()
	local w = screen.x/1.5
	self.bar = loading_bar(screen.x/2 - w/2, screen.y * 0.75, w, 32, 12)
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
	self.done_count = 0
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
			log.trace("ASSETS:")
			print(inspect(resourceManager.__assets))
			self.n = 0
			self.toLoad = {}
			self.userdata = {}
			self.done_count = self.done_count + 1
			-- self.lily = nil
			-- self.isActive = false
		end)
end

function Preload:update(dt)
	self:checkGamestate()
	if self.isActive then
		if self.lily then
			local nLoaded = self.lily:getLoadedCount()
			local nTotal = self.lily:getCount()
			if nLoaded ~= 0 then
				local percent = nLoaded/nTotal * 100
				self.bar:update(percent)
			end
		end
	end
	if self.bar.isDone and self.done_count < 2 then
		self.done_count = self.done_count + 1
		self.isActive = false
	end
end

function Preload:checkGamestate()
	if not (self.current == gamestate.current()) then
		log.trace("State is changed!")
		self.current = gamestate.current()
		log.trace("Checking for state's assets...")
		if self.current.assets then
			log.trace("Checking and validating...")
			self:check(self.current.assets)
		end
	end
end

function Preload:draw()
	if self.isActive then
		self.colors.bg:setBG()
		self.colors.bar:set()
		self.bar:draw()
	end
end

function Preload:getState()
	return self.isActive
end

return Preload
