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
	button_back = req("button_back"),
	button_volume = req("button_volume"),
	button_twitter = req("button_twitter"),
	title = req("title"),
	window = req("window"),
	window_title = req("window_title"),
	window_body = req("window_body"),
	blur = req("blur"),
	loading = req("loading"),
}

return Entities
