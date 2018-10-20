local Assets = {}

local sfx = {"alert","back","forward","hover1","click1","click2","click3","click4","click5","wrong","page_turn"}
local buttons = {"bag","play","store","home","settings","mute","volume","cat","star","twitter"}
local colours = {"back","forward","yellow","green","purple","red","blue","grayscale","softmilk","black","white","lime","orange","pink"}
local palettes = {"source", "softmilk", "blue", "green", "grayscale"}
local states = {"attack","blink","dizzy","heart","hurt","mouth","sleep","snore","spin"}
local items = {"walk","jump","attack"}
local maps = {"mars","underground","space","earth"}
local displays = {"mars","caverns","space","earth"}

local maxPatterns = 9

function Assets:finalize(t)
	for i, str in ipairs(sfx) do
		local id = "sfx_" .. str
		local path = "assets/sounds/sfx/" .. str .. ".ogg"
		table.insert(t.sources, { id = id, path = path, kind = "static" })
	end
	for i = 1, maxPatterns do
		local id = "pattern" .. i
		local path = "assets/images/pattern" .. i .. ".png"
		table.insert(t.images, { id = id, path = path })
	end
	for _, btn in ipairs(buttons) do
		local id = "button_" .. btn
		local id_hovered = "button_" .. btn .. "_hovered"
		local path = "assets/gui/" .. id .. ".png"
		local path_hovered = "assets/gui/" .. id_hovered .. ".png"
		table.insert(t.images, { id = id, path = path })
		table.insert(t.images, { id = id_hovered, path = path_hovered })
	end
	for i, state in ipairs(states) do
		local id = "sheet_cat_" .. state
		local path = "assets/anim/cat_" .. state .. ".png"
		table.insert(t.images, { id = id, path = path })
	end
	for _, palette in ipairs(palettes) do
		for _, state in ipairs(states) do
			local id = ("pal_%s_%s"):format(state, palette)
			local path = ("assets/palettes/%s/%s.png"):format(palette, state)
			table.insert(t.images, { id = id, path = path })
		end
	end
	for i = 1, 4 do
		local id = "window_settings" .. i
		local path = "assets/gui/" .. id .. ".png"
		table.insert(t.images, { id = id, path = path })
	end
	-- for i, item in ipairs(items) do
	-- 	local id = "item_" .. item
	-- 	local id_hovered = id .. "_hovered"
	-- 	local path = "assets/gui/" .. id .. ".png"
	-- 	local path_hovered = "assets/gui/" .. id_hovered .. ".png"
	-- 	table.insert(t.images, { id = id, path = path })
	-- 	table.insert(t.images, { id = id_hovered, path = path_hovered })
	-- end
	for _,btn in ipairs(colours) do
		local id = "btn_" .. btn
		local id_hovered = id .. "_hovered"
		local path = "assets/gui/button_" .. btn .. ".png"
		local path_hovered = "assets/gui/button_" .. btn .. "_hovered.png"
		table.insert(t.images, { id = id, path = path })
		table.insert(t.images, { id = id_hovered, path = path_hovered })
	end
	for i,map in ipairs(maps) do
		local id = "map_" .. map
		local path = "assets/images/" .. id .. ".png"
		table.insert(t.images, { id = id, path = path })
	end
	for i,display in ipairs(displays) do
		local id = "display_" .. display
		local path = "assets/images/" .. id .. ".png"
		table.insert(t.images, { id = id, path = path })
	end

	return t
end

return Assets
