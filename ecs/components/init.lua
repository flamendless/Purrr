local path = "ecs.components."

local req = function(id)
	return require(path .. id)
end

local Components = {
	color = req("color"),
	colors = req("colors"),
	sprite = req("sprite"),
	pos = req("pos"),
	transform = req("transform"),
	tween = req("tween"),
	targetPos = req("targetPos"),
	text = req("text"),
	glitch = req("glitch"),
	rect = req("rect"),
	cornerRadius = req("cornerRadius"),
	shapeTransform = req("shapeTransform"),
	changeColor = req("changeColor"),
	circle = req("circle"),
	points = req("points"),
	debug = req("debug"),
	spin = req("spin"),
	fillMode = req("fillMode"),
	ease = req("ease"),
}

return Components
