local Preload = {}

local gamestate = require("modules.hump.gamestate")
local log = require("modules.log.log")
local lily = require("modules.lily.lily")
local inspect = require("modules.inspect.inspect")
local timer = require("modules.hump.timer")
local flux = require("modules.flux.flux")

local screen = require("src.screen")
local colors = require("src.colors")
local loading_bar = require("src.loading_bar")

local _called = false
local dur_last = 1.25
if __debug then dur_last = 0.2 end

function Preload:init()
	self.colors = {
		bg = colors("flat", "black", "dark"),
		main = colors("flat", "white", "light"),
	}
	self.toLoad = {}
	self.userdata = {}
	self.n = 1
	self.txt = "LOADING"
	self.id_font = "loading"
	local w = 320
	self.bar = loading_bar(
		screen.x/2 - w/2,
		screen.y * 0.75,
		w, 32, 12)
end

function Preload:enter(previous, ...)
	self.colors.bg:setBG()
	self.done = false
	self:processImages()
	self:processFonts()
	self.lily = lily.loadMulti(self.toLoad)
		:setUserData(self.userdata)
		:onLoaded(function(id, i, data)
			if id then
				local kind = string.lower(data:type() .. "s")
				if not ASSETS[kind] then ASSETS[kind] = {} end
				if data.setFilter then
					data:setFilter(__filter, __filter)
				end
				ASSETS[kind][id[i]] = data
				log.trace(("Loaded: %s - %s"):format(kind, id[i]))
			end
		end)
		:onComplete(function()
			self.toLoad = {}
			self.userdata = {}
			self.n = self.n + 1
			self.done = true
			log.trace("ASSETS:")
			print(inspect(ASSETS))
		end)
end

function Preload:update(dt)
	if not self.state then return end
	if not self.done or not self.bar.isDone then
		local nLoaded = self.lily:getLoadedCount()
		local nTotal = self.lily:getCount()
		if nLoaded ~= 0 then
			local percent = nLoaded/nTotal * 100
			self.txt = ("LOADING %2i%%"):format(percent)
			self.bar:update(percent)
		end
	end
	if self.done and self.bar.isDone then
		if not _called then
			_called = true
			flux.to(self.colors.main, dur_last, { [4] = 0 })
				:oncomplete(function()
					gamestate.switch(next_state)
				end)
		end
	end
end

function Preload:draw()
	if not self.state then return end
	self.colors.main:set()
	if ASSETS.fonts[self.id_font] then
		local font = ASSETS.fonts[self.id_font]
		love.graphics.setFont(font)
		love.graphics.printf(self.txt,
			0, screen.y * 0.75 - font:getHeight(self.txt),
			screen.x, "center")
	end
	self.bar:draw()
end

function Preload:processImages()
	for id, path in pairs(assets.images) do
		self.toLoad[self.n] = { "newImage", path }
		self.userdata[self.n] = id
		self.n = self.n + 1
	end
end

function Preload:processFonts()
	for i = 1 , #assets.fonts do
		local t = assets.fonts[i]
		if t.sizes then
			for size = 1, #t.sizes do
				self.toLoad[self.n] = { "newFont", t.path, t.sizes[size] }
				self.userdata[self.n] = t.id .. "_" .. t.sizes[size]
				self.n = self.n + 1
			end
		else
			self.toLoad[self.n] = { "newFont", t.path, t.size }
			self.userdata[self.n] = t.id
			self.n = self.n + 1
		end
	end
end

return Preload
