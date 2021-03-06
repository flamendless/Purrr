local path = "states."

local req = function(id)
	return require(path .. id)
end

local States = {
	splash = req("splash"),
	menu = req("menu"),
	lobby = req("lobby"),
	intro = req("intro"),
	customization = req("customization"),
	map = req("map"),
	bag = req("bag"),
	store = req("store"),
}

return States
