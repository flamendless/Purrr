local path = "states."

local req = function(id)
	return require(path .. id)
end

local States = {
	splash = req("splash"),
}

return States
