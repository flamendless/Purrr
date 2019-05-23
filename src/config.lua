local Config = {
	filename = "save.lua",
	path = love.filesystem.getSaveDirectory() .. "/"
}
local serialize = require("modules.knife.knife.serialize")
local log = require("modules.log.log")

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

function Config:init()
	self.data = {}
	self.data.flags = {}
	self.data.game = {}
	self.data.dev = {}
	if love.filesystem.getInfo(self.filename) then
		self.data = require(stripExtension(self.filename))
		log.trace("File Loaded!")
	else
		self.data.flags.new_game = true
		self.data.flags.customization_done = false
		self.data.flags.has_name = false

		self.data.game.version = __version
		self.data.game.cat_name = "?default"
		self.data.game.palette = "?default"
		self.data.game.volume = 1

		self.data.dev.twitter = "https://twitter.com/flamendless"
		self.data.dev.playstore = "https://twitter.com/flamendless"
	end

	self:check()
end

function Config:check()
	local data_version = convert(self.data.game.version)
	local game_version = convert(__version)
	self.data.game.version = data_version

	log.trace(("Game Version: %s : Save Version: %s"):format(game_version, data_version))
	if not (data_version == game_version) then
		local success = love.filesystem.remove(self.filename)
		self.data.game.version = __version
		self:save()
	end
end

function Config:save()
	local save = serialize(self.data)
	love.filesystem.write(self.filename, save)
	log.trace("File Saved!")
end

function Config:erase()
	love.filesystem.remove(self.filename)
	self:init()
	self:save()
end

return Config
