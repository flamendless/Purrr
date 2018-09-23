local path = "ecs.components."

local req = function(id)
	return require(path .. id)
end

local Components = {
	color = req("color"),
	sprite = req("sprite"),
	pos = req("pos"),
	transform = req("transform"),
	tween = req("tween"),
	targetPos = req("targetPos"),
	text = req("text"),
}

return Components
