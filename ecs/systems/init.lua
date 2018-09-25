local path = "ecs.systems."

local req = function(id)
	return require(path .. id)
end

local Systems = {
	renderer = req("renderer"),
	transform = req("transform"),
	tweenTo = req("tweenTo"),
	glitchEffect = req("glitchEffect"),
	squareTransform = req("squareTransform"),
	changeColor = req("changeColor"),
}

return Systems
