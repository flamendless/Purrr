local path = "ecs.components."

local req = function(id)
	return require(path .. id)
end

local Components = {
	alpha_fade = req("alpha_fade"),
	animation = req("animation"),
	background = req("background"),
	collider_rect = req("collider_rect"),
	collider_sprite = req("collider_sprite"),
	color = req("color"),
	fade_state = req("fade_state"),
	font = req("font"),
	gui_button = req("gui_button"),
	gui_onClick = req("gui_onClick"),
	onHoveredSprite = req("onHoveredSprite"),
	sprite = req("sprite"),
	tag = req("tag"),
	text = req("text"),
	transform = req("transform"),
}

return Components
