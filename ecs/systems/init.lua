local path = "ecs.systems."

local req = function(id)
	return require(path .. id)
end

local Systems = {
	renderer = req("renderer"),
	transform = req("transform"),
	tweenTo = req("tweenTo"),
	changeColor = req("changeColor"),
	spinner = req("spinner"),
	animation = req("animation"),
	position = req("position"),
	patrol = req("patrol"),
	moveTo = req("moveTo"),
	gui = req("gui"),
	collision = req("collision"),
	follow = req("follow"),
	windows = req("windows"),
	customize_cat = req("customize_cat"),
	cat_fsm = req("cat_fsm"),
	event_listener = req("event_listener"),
	textinput = req("textinput"),
	window_manager = req("window_manager"),
}

return Systems
