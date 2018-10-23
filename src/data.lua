local Data = {}
local serialize = require("modules.knife.knife.serialize")
local log = require("modules.log.log")
local semver = require("modules.semver.semver")

local file_save = "save.lua"
local dir_save = love.filesystem.getSaveDirectory() .. "/"

local stripExtension = function(str)
	return str:match("(.+)%..+")
end

local convert = function(t)
	if t then
		return ("%s.%s.%s"):format(t.major, t.minor, t.patch)
	else
		return "Version not found!"
	end
end

function Data:init()
	self.data = {}
	if love.filesystem.getInfo(file_save) then
		self.data = require(stripExtension(file_save))
		log.trace("File Loaded!")
	else
		self.data.version = __version
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

	self:check()
end

function Data:check()
	local data_version = convert(self.data.version)
	local game_version = convert(__version)
	log.trace(("Game Version: %s : Save Version: %s"):format(game_version, data_version))
	if not (data_version == game_version) then
		local success = love.filesystem.remove(file_save)
		self.data.version = __version
		self:save()
	end
end

function Data:save()
	local save = serialize(self.data)
	love.filesystem.write(file_save, save)
	log.trace("File Saved!")
end

return Data
