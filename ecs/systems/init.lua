local path = "ecs.systems."

local req = function(id)
	return require(path .. id)
end

local Systems = {
	alpha_fade = req("alpha_fade"),
	collider = req("collider"),
	renderer = req("renderer"),
}

return Systems
