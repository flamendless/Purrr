local Event = {}

local transition = require("src.transition")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local colors = require("src.colors")
local screen = require("src.screen")
local lume = require("modules.lume.lume")
local inspect = require("modules.inspect.inspect")

function Event:init()
	self.colors = {
		cover = colors("flat", "black", "dark", 0.8)
	}
end

function Event:getName()
	self:checkAssets()
	local spr_window = lume.randomchoice(self.gui)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "window", window,
		{
			spr_window = spr_window,
			str_title = "Choose Your Cat's Name",
			font_title = self.fonts.title,
			-- str_content = "Input Name:",
			-- font_content = self.fonts.content,

			button1 = {
				disabled = true,
				id = "Accept",
				normal = self.images.accept,
				hovered = self.images.accept_hovered,
				onClick = function()
					window:close()
				end
			},

			textinput = {
				font = self.fonts.content
			}
		})
end

function Event:showExitConfirmation()
	self:checkAssets()
	local spr_window = lume.randomchoice(self.gui)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "window", window,
		{
			spr_window = spr_window,
			str_title = "CONFIRMATION",
			font_title = self.fonts.title,
			str_content = "Are you sure you want to quit?",
			font_content = self.fonts.content,
			button1 = {
				id = "Accept",
				normal = self.images.accept,
				hovered = self.images.accept_hovered,
				onClick = function()
					window:close()
					transition.color = { 0, 0, 0, 1 }
					transition:start(function()
						love.event.quit()
					end)
				end
			},
			button2 = {
				id = "Cancel",
				normal = self.images.cancel,
				hovered = self.images.cancel_hovered,
				onClick = function()
					window:close()
				end
			}
		})
end

function Event:showHomeConfirmation()
	self:checkAssets()
	local window = require("ecs.instances.window")
	local spr_window = lume.randomchoice(self.gui)
	gamestate:addInstance( "window", window,
		{
			spr_window = spr_window,
			str_title = "CONFIRMATION",
			font_title = self.fonts.title,
			str_content = "Are you sure you want to return to menu screen?",
			font_content = self.fonts.content,
			button1 = {
				id = "Accept",
				normal = self.images.accept,
				hovered = self.images.accept_hovered,
				onClick = function()
					window:close()
					transition:start( require("states.menu") )
				end
			},
			button2 = {
				id = "Cancel",
				normal = self.images.cancel,
				hovered = self.images.cancel_hovered,
				onClick = function()
					window:close()
				end
			}
		})
end

function Event:drawCover()
	self.colors.cover:set()
	love.graphics.rectangle("fill", 0, 0, screen.x, screen.y)
end

function Event:checkAssets()
	if not self.gui then
		self.gui = {
			[1] = resourceManager:getImage("window_red"),
			[2] = resourceManager:getImage("window_green"),
			[3] = resourceManager:getImage("window_blue")
		}
	end
	if not self.images then
		self.images = {
			accept = resourceManager:getImage("btn_accept"),
			accept_hovered = resourceManager:getImage("btn_accept_hovered"),
			cancel = resourceManager:getImage("btn_cancel"),
			cancel_hovered = resourceManager:getImage("btn_cancel_hovered"),
		}
	end
	if not self.fonts then
		self.fonts = {
			title = resourceManager:getFont("upheaval_42"),
			content = resourceManager:getFont("upheaval_32"),
			button = resourceManager:getFont("upheaval_28"),
		}
	end
end

return Event
