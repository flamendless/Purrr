local path = "ecs.components."

local req = function(id)
	return require(path .. id)
end

local Components = {
	animation = req("animation"),
	background = req("background"),
	onHoveredSprite = req("onHoveredSprite"),
	collider_rect = req("collider_rect"),
	collider_sprite = req("collider_sprite"),
	color = req("color"),
	gui_button = req("gui_button"),
	gui_onClick = req("gui_onClick"),
	sprite = req("sprite"),
	tag = req("tag"),
	transform = req("transform"),
}

return Components
