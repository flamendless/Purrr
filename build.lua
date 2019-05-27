local pp = require("modules.luapreprocess.preprocess")

pp.metaEnvironment._DEBUG = true
pp.metaEnvironment._LOGGING = true
pp.metaEnvironment._PLATFORM = "desktop"

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
		dir_out = "bin/src/"
	},
	{
		dir = getLuaFilesInDirectory("states"),
		dir_in = "^states/",
		dir_out = "bin/states/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/components"),
		dir_in = "^ecs/components/",
		dir_out = "bin/ecs/components/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/systems"),
		dir_in = "^ecs/systems/",
		dir_out = "bin/ecs/systems/"
	},
	{
		dir = getLuaFilesInDirectory("ecs/entities"),
		dir_in = "^ecs/entities/",
		dir_out = "bin/ecs/entities/"
	},
}

for _, t in ipairs(all_paths) do
	for _, filename in ipairs(t.dir) do
		local pathOut = filename
		pathOut = pathOut:gsub(t.dir_in, t.dir_out)
		pathOut = pathOut:gsub("%.lua2p$", ".lua")
		if pathOut == "bin/src/main.lua" then
			pathOut = "bin/main.lua"
		end
		local info, err = pp.processFile({pathIn = filename, pathOut = pathOut})
		if not info then  os.exit(1)  end
	end
end
