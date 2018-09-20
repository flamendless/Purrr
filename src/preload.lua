local Preload = {}

local lily = require("modules.lily.lily")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local gamestate = require("modules.hump.gamestate")

local resourceManager = require("src.resource_manager")

function Preload:init()
	self.toLoad = {}
	self.userdata = {}
	self.n = 0
	self.isActive = false
	self.current = gamestate.current()
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
			self.isActive = false
		end)
end

function Preload:update(dt)
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

end

function Preload:getState()
	return self.isActive
end

return Preload
