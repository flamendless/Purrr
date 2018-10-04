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
	rect = req("rect"),
	circle = req("circle"),
	debug = req("debug"),
	anim = req("anim"),
	parent = req("parent"),
	offsetPos = req("offsetPos"),
	patrol = req("patrol"),
	speed = req("speed"),
	moveTo = req("moveTo"),
	anim_callback = req("anim_callback"),
}

return Components
