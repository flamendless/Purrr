local Event = {}

local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local colors = require("src.colors")
local screen = require("src.screen")
local lume = require("modules.lume.lume")
local inspect = require("modules.inspect.inspect")

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
	if not self.gui then
		self.gui = {
			[1] = resourceManager:getImage("window_red"),
			[2] = resourceManager:getImage("window_green"),
			[3] = resourceManager:getImage("window_blue")
		}
	end
	if not self.images then
		self.images = {
			normal = resourceManager:getImage("button"),
			hovered = resourceManager:getImage("hovered_button")
		}
	end
	if not self.fonts then
		self.fonts = {
			title = resourceManager:getFont("upheaval_42"),
			content = resourceManager:getFont("upheaval_32"),
			button = resourceManager:getFont("upheaval_28"),
		}
	end

	local spr_window = lume.randomchoice(self.gui)
	gamestate:addInstance( "window", require("ecs.instances.window"),
		{
			spr_window = spr_window,
			str_title = "CONFIRMATION",
			font_title = self.fonts.title,
			str_content = "Are you sure you want to quit?",
			font_content = self.fonts.content,
			button1 = {
				id = "Accept",
				text = "Accept",
				font = self.fonts.button,
				normal = self.images.normal,
				hovered = self.images.hovered,
			},
			button2 = {
				id = "Cancel",
				text = "Cancel",
				font = self.fonts.button,
				normal = self.images.normal,
				hovered = self.images.hovered,
			}
		})
end

function Event:drawCover()
	self.colors.cover:set()
	love.graphics.rectangle("fill", 0, 0, screen.x, screen.y)
end

return Event
