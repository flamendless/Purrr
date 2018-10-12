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
	patch = req("patch"),
	button = req("button"),
	colliderBox = req("colliderBox"),
	hoveredSprite = req("hoveredSprite"),
	follow = req("follow"),
	textShadow = req("textShadow"),
	hoveredColor = req("hoveredColor"),
	float = req("float"),
	tween_onComplete = req("tween_onComplete"),
	maxScale = req("maxScale"),
	windowIndex = req("windowIndex"),
	attachToWindow = req("attachToWindow"),
	window = req("window"),
	textPad = req("textPad"),
}

return Components
