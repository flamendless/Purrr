local Assets = {}

local sfx = {"alert","back","forward","hover1","click1","click2","click3","click4","click5","wrong","page_turn"}
local items = {"walk","jump","attack"}

function Assets:finalize(t)
	-- for i, item in ipairs(items) do
	-- 	local id = "item_" .. item
	-- 	local id_hovered = id .. "_hovered"
	-- 	local path = "assets/gui/" .. id .. ".png"
	-- 	local path_hovered = "assets/gui/" .. id_hovered .. ".png"
	-- 	table.insert(t.images, { id = id, path = path })
	-- 	table.insert(t.images, { id = id_hovered, path = path_hovered })
	-- end
end

function Assets:getMusic(t)
	for i, str in ipairs(sfx) do
		local id = "sfx_" .. str
		local path = "assets/sounds/sfx/" .. str .. ".ogg"
		if not t.sources then t.sources = {} end
		table.insert(t.sources, { id = id, path = path, kind = "static" })
	end
	return t
end

return Assets
