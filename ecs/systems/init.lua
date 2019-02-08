local path = "ecs.systems."

local req = function(id)
	return require(path .. id)
end

local Systems = {
	animation = req("animation"),
	collider = req("collider"),
	renderer = req("renderer"),
	gui = req("gui"),
}

return Systems
