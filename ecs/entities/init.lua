local path = "ecs.entities."

local req = function(id)
	return require(path .. id)
end

local Entities = {
	scene = req("scene"),
	color_picker = req("color_picker"),
	lobby_button = req("lobby_button"),
	button_play = req("button_play"),
	button_quit = req("button_quit"),
	button_erase = req("button_erase"),
	button_settings = req("button_settings"),
	button_accept = req("button_accept"),
	button_cancel = req("button_cancel"),
	button_back = req("button_back"),
	button_volume = req("button_volume"),
	button_twitter = req("button_twitter"),
	button_forward = req("button_forward"),
	lock = req("lock"),
	notice = req("notice"),
	title = req("title"),
	window = req("window"),
	window_title = req("window_title"),
	window_body = req("window_body"),
	blur = req("blur"),
	loading = req("loading"),
	textinput = req("textinput"),
	cat = req("cat"),
	header = req("header"),
	lobby_window = req("lobby_window"),
}

return Entities
