local Positions = {}
local vec2 = require("modules.hump.vector")
local screen = require("src.screen")

Positions.window = {}
Positions.window.pad = 32
Positions.window.title_pad = 64
Positions.window.body_pad = 86
Positions.window.title = vec2(-(screen.x - Positions.window.title_pad)/2, -screen.y * 0.35)
Positions.window.title2 = vec2(-(screen.x - Positions.window.title_pad)/2, -screen.y * 0.2)
Positions.window.body = vec2(-(screen.x - Positions.window.body_pad)/2, -screen.y * 0.1)
Positions.window.body2 = vec2(-(screen.x - Positions.window.body_pad)/2)
Positions.window.twitter = vec2(128, 0)
Positions.window.erase = vec2(-128, 0)

Positions.screen = {}
Positions.screen.top = vec2(screen.x/2, -screen.y/2)
Positions.screen.bottom = vec2(screen.x/2, screen.y * 1.5)
Positions.screen.left = vec2(-screen.x/2)

Positions.menu = {}
Positions.menu.title = vec2(0, screen.y * 0.25)
Positions.menu.play = vec2(0, screen.y * 0.65)
Positions.menu.quit = vec2(0, 128)
Positions.menu.settings = vec2(screen.x - 32, screen.y - 32)

Positions.customization = {}
Positions.customization.off_cat = vec2(screen.x/2, -screen.y/2)
Positions.customization.off_header = vec2(screen.x/2, -screen.y/2)
Positions.customization.off_forward = vec2(screen.x * 0.82, screen.y * 1.5)
Positions.customization.off_back = vec2(screen.x * 0.18, screen.y * 1.5)
Positions.customization.off_lock = vec2(-screen.x * 1.5, screen.y * 0.75)
Positions.customization.off_notice = vec2(screen.x + 16, screen.y * 0.55)
Positions.customization.cat = vec2(0, screen.y * 0.3)
Positions.customization.back = vec2(0, screen.y * 0.9)
Positions.customization.forward = vec2(0, screen.y * 0.9)
Positions.customization.header = vec2(0, 72)
Positions.customization.lock = vec2(screen.x/2)
Positions.customization.notice = vec2(16)

Positions.color_picker = {}
Positions.color_picker.default = vec2(screen.x * 0.2, screen.y * 0.55)
Positions.color_picker.softmilk = vec2(screen.x * 0.5, screen.y * 0.55)
Positions.color_picker.grayscale = vec2(screen.x * 0.8, screen.y * 0.55)
Positions.color_picker.red = vec2(screen.x * 0.2, screen.y * 0.65)
Positions.color_picker.green = vec2(screen.x * 0.5, screen.y * 0.65)
Positions.color_picker.blue = vec2(screen.x * 0.8, screen.y * 0.65)
Positions.color_picker.purple = vec2(screen.x * 0.2, screen.y * 0.75)
Positions.color_picker.black = vec2(screen.x * 0.5, screen.y * 0.75)
Positions.color_picker.white = vec2(screen.x * 0.8, screen.y * 0.75)
Positions.color_picker.orange = vec2(screen.x * 0.5, screen.y * 0.85)

Positions.lobby = {}
Positions.lobby.window = vec2(screen.x/2, screen.y)
Positions.lobby.settings = vec2(screen.x - 32, 32)
Positions.lobby.home = vec2(screen.x - 112, 32)
Positions.lobby.cat = vec2(0, screen.y/2)
Positions.lobby.energy = vec2(112, 32)
Positions.lobby.cat_info = vec2(32, 32)

return Positions
