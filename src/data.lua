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
		for k,v in pairs(self.data) do print(k,v) end
		log.trace("File Loaded!")
	else
		self.data.new_game = true
		self.data.customization = true
		self.data.cat_name = "ponkan"
		self.data.palette = "source"
	end
end

function Data:save()
	local save = serialize(self.data)
	love.filesystem.write(file_save, save)
	log.trace("File Saved!")
end

return Data
