local Data = {}
local serialize = require("modules.knife.knife.serialize")
local log = require("modules.log.log")

local file_save = "save.lua"
local dir_save = love.filesystem.getSaveDirectory() .. "/"

local stripExtension = function(str)
	return str:match("(.+)%..+")
end

function Data:init()
	self.data = {}
	if love.filesystem.getInfo(file_save) then
		self.data = require(stripExtension(file_save))
		log.trace("File Loaded!")
	else
		self.data.new_game = true
		self.data.customization = true
		self.data.cat_name = "ponkan"
		self.data.got_name = false
		self.data.palette = "source"
		self.data.energy = "full"
		self.data.volume = 1
		self.data.world = "mars"
		self.data.level = 1
		self.data.coins = 500
		self.data.skills = {
			walk = false,
			jump = false,
			attack = false,
		}
		self.data.locked = {
			mars = false,
			underground = true,
			space = true,
			earth = true
		}
	end
	self.dev = {}
	self.dev.twitter = "https://twitter.com/flamendless"
	self.dev.playstore = "https://twitter.com/flamendless"
end

function Data:save()
	local save = serialize(self.data)
	love.filesystem.write(file_save, save)
	log.trace("File Saved!")
end

return Data
