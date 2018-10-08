local Event = {}

local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local colors = require("src.colors")
local screen = require("src.screen")
local lume = require("modules.lume.lume")

function Event:_showExitConfirmation()
	local title = "Confirmation"
	local message = "Are you sure you want to quit the game?"
	local buttons = {"OK", "No!", escapebutton = 2}
	local pressedbutton = love.window.showMessageBox(title, message, buttons)
	if pressedbutton == 1 then
		love.event.quit()
	end
end

function Event:init()
	self.colors = {
		cover = colors("flat", "black", "dark", 0.8)
	}
end

function Event:showExitConfirmation()
	if not self.images then
		self.images = {
			[1] = resourceManager:getImage("window_red"),
			[2] = resourceManager:getImage("window_green"),
			[3] = resourceManager:getImage("window_blue")
		}
	end

	local spr_window = lume.randomchoice(self.images)
	gamestate:addInstance( "window", require("ecs.instances.window"),
		spr_window,
		"CONFIRMATION",
		resourceManager:getFont("title_42"))
end

function Event:drawCover()
	self.colors.cover:set()
	love.graphics.rectangle("fill", 0, 0, screen.x, screen.y)
end

return Event
