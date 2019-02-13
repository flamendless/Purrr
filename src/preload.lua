local Preload = {}

local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}
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

local dur = 1.5
if __debug then dur = 0.25 end

function Preload:init()
	self.colors = {
		bg = colors("flat", "black", "dark"),
		text = colors("flat", "white", "dark"),
	}

	self.current_state = nil
	self.toLoad = {}
	self.userdata = {}
	self.n = 1
	self.isActive = false
end

function Preload:check(t_assets, current_state)
	for kind, t in pairs(t_assets) do
		for i, v in pairs(t) do
			if not resourceManager:check(kind, v.id) then
				self:add(kind, v)
				self.current_state = current_state
			else
				log.trace(("%s - already loaded!"):format(v.id))
			end
		end
	end
	if self.n > 1 then
		self:start()
	else
		self:complete()
	end
end

function Preload:add(kind, data)
	if kind == "images" then
		self.toLoad[self.n] = { "newImage", data.path }
		self.userdata[self.n] = data.id
		self.n = self.n + 1
	elseif kind == "ImageData" then
		self.toLoad[self.n] = { "newImageData", data.path }
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
	elseif kind == "sources" then
		self.toLoad[self.n] = { "newSource", data.path, data.kind }
		self.userdata[self.n] = data.id
		self.n = self.n + 1
	end
end

function Preload:start()
	self.preloaderDone = false
	self.isActive = true
	require("src.gamestate"):enablePreloading()
	self.lily = lily.loadMulti(self.toLoad)
		:setUserData(self.userdata)
		:onLoaded(function(id, i, data)
			if id then
				local kind
				local data_type = string.lower(data:type() .. "s")
				if data_type == "images" or data_type == "fonts" or data_type == "sources" then
					kind = data_type
				else
					kind = data:type()
				end
				log.trace(("Loaded: %s - %s"):format(kind, id[i]))
				resourceManager:add(kind, id[i], data, self.current_state)
			end
		end)
		:onComplete(function()
			self:complete()
		end)
end

function Preload:draw()
	if self.isActive then
		self.colors.bg:setBG()
	end
end

function Preload:complete()
	resourceManager:setFilter()
	log.trace("ASSETS:")
	flux.to(self.colors.text, 1, { [4] = 0 })
	timer.after(dur, function()
		self.isActive = false
		self.n = 1
		self.toLoad = {}
		self.userdata = {}
		require("src.gamestate"):disablePreloading()
	end)
end

function Preload:getState() return self.isActive end

return Preload
