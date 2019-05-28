local pp = require("modules.luapreprocess.preprocess")

pp.metaEnvironment._DEBUG = true
pp.metaEnvironment._LOGGING = true
pp.metaEnvironment._PLATFORM = "desktop"
pp.metaEnvironment._GAME_VERSION = { 0, 0, 4 }

local getLuaFilesInDirectory = function(str)
	local f = io.popen("ls " .. str)
	if f then
		local files = {}
		for line in f:lines() do
			local path = str .. "/" .. line
			table.insert(files, path)
		end
		return files
	end
	return nil
end

local all_paths = {
	{
		dir = getLuaFilesInDirectory("src"),
		dir_in = "^src/",
		dir_out = "output/src/"
	},
	{
		dir = getLuaFilesInDirectory("states"),
		dir_in = "^states/",
		dir_out = "output/states/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/components"),
		dir_in = "^ecs/components/",
		dir_out = "output/ecs/components/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/systems"),
		dir_in = "^ecs/systems/",
		dir_out = "output/ecs/systems/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/entities"),
		dir_in = "^ecs/entities/",
		dir_out = "output/ecs/entities/"
	},
}

for _, t in ipairs(all_paths) do
	for _, filename in ipairs(t.dir) do
		local pathOut = filename
		pathOut = pathOut:gsub(t.dir_in, t.dir_out)
		pathOut = pathOut:gsub("%.lua2p$", ".lua")
		if pathOut == "output/src/main.lua" then
			pathOut = "output/main.lua"
		elseif pathOut == "output/src/conf.lua" then
			pathOut = "output/conf.lua"
		end
		local info, err = pp.processFile({pathIn = filename, pathOut = pathOut})
		if not info then  os.exit(1)  end
	end
end
