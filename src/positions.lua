local Positions = {}
local vec2 = require("modules.hump.vector")
local screen = require("src.screen")

Positions.window = {}
Positions.window.title_pad = 64
Positions.window.body_pad = 86
Positions.window.title = vec2(-(screen.x - Positions.window.title_pad)/2, -screen.y * 0.35)
Positions.window.body = vec2(-(screen.x - Positions.window.body_pad)/2, -screen.y * 0.1)
Positions.window.twitter = vec2(128, 0)
Positions.window.erase = vec2(-128, 0)

Positions.screen = {}
Positions.screen.top = vec2(screen.x/2, -screen.y/2)
Positions.screen.bottom = vec2(screen.x/2, screen.y * 1.5)

Positions.menu = {}
Positions.menu.title = vec2(0, screen.y * 0.25)
Positions.menu.play = vec2(0, screen.y * 0.65)
Positions.menu.quit = vec2(0, 128)
Positions.menu.settings = vec2(screen.x - 32, screen.y - 32)

return Positions
