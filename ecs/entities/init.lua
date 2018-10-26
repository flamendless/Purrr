local path = "ecs.entities."

local req = function(id)
	return require(path .. id)
end

local Entities = {
	scene = req("scene"),
	color_picker = req("color_picker"),
	lobby_buttons = req("lobby_buttons"),
	button_play = req("button_play"),
	button_quit = req("button_quit"),
	button_erase = req("button_erase"),
	button_settings = req("button_settings"),
	button_accept = req("button_accept"),
	button_cancel = req("button_cancel"),
	title = req("title"),
	window = req("window"),
}

return Entities
