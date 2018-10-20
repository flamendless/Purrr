local Assets = {}

local sfx = {"alert","back","forward","hover1","click1","click2","click3","click4","click5","wrong","page_turn","buy","coins1","coins2","coins3"}
local cat = {"purrr","snore"}
local bgm = {"lobby1","lobby2","intro","main_menu","customization","map1","map2"}

function Assets:getMusic(t)
	for i, str in ipairs(sfx) do
		local id = "sfx_" .. str
		local path = "assets/sounds/sfx/" .. str .. ".ogg"
		if not t.sources then t.sources = {} end
		table.insert(t.sources, { id = id, path = path, kind = "static" })
	end
	for i, str in ipairs(bgm) do
		local id = "bgm_" .. str
		local path = "assets/sounds/bgm/" .. str .. ".ogg"
		if not t.sources then t.sources = {} end
		table.insert(t.sources, { id = id, path = path, kind = "stream" })
	end
	for i, str in ipairs(cat) do
		local id = "cat_" .. str
		local path = "assets/sounds/cat/" .. id .. ".ogg"
		if not t.sources then t.sources = {} end
		table.insert(t.sources, { id = id, path = path, kind = "static" })
	end
	return t
end

return Assets
