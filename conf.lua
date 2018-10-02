function love.conf(t)
	local __debug = true

	t.window.title = "Android Masters 2018"
	t.window.width = 480
	t.window.height = 800
	t.window.fullscreen = love._os == "Android" or love._os == "iOS"
	t.window.fullscreentype = "desktop"
	t.window.resizable = false
	t.externalstorage = false
	t.console = true
	t.identity = "am2018"
	t.version = "11.1"

	if __debug then
		t.window.x = 1280 - t.window.width - 32
	end
end
