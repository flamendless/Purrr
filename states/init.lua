local path = "states."

local req = function(id)
	return require(path .. id)
end

local States = {
	splash = req("splash"),
	menu = req("menu"),
	lobby = req("lobby"),
}

return States
