function love.conf(t)
	t.window.title = "Purrr"
	t.window.width = 640
	t.window.height = 360
	t.window.fullscreen = love._os == "Android" or love._os == "iOS"
	t.window.fullscreentype = "desktop"
	t.window.resizable = false
	t.externalstorage = true
	t.console = false
	t.identity = "purrr"
	t.version = "11.1"

	if not (love._os == "Android" or love._os == "iOS") then
		t.window.x = 1280 - t.window.width - 32
	end
end
