local path = "ecs.components."

local req = function(id)
	return require(path .. id)
end

local Components = {
	animation = req("animation"),
	color = req("color"),
	sprite = req("sprite"),
	transform = req("transform"),
}

return Components
