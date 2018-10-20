local Event = {}
local C = require("ecs.components")

local transition = require("src.transition")
local resourceManager = require("src.resource_manager")
local gamestate = require("src.gamestate")
local colors = require("src.colors")
local screen = require("src.screen")
local data = require("src.data")
local lume = require("modules.lume.lume")
local inspect = require("modules.inspect.inspect")

local opened_id

function Event:init()
	self.colors = {
		cover = colors("flat", "black", "dark", 0.8)
	}
end

function Event:showSettings()
	if not self:checkAssets() then return end
	opened_id = "Window_ShowSettings"
	local btn_volume, btn_volume_hovered
	if data.data.volume == 1 then
		btn_volume = resourceManager:getImage("button_volume")
		btn_volume_hovered = resourceManager:getImage("button_volume_hovered")
	elseif data.data.volume == 0 then
		btn_volume = resourceManager:getImage("button_mute")
		btn_volume_hovered = resourceManager:getImage("button_mute_hovered")
	end
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_GetName", window,
		{
			spr_window = self.images.window_settings,
			str_title = "SETTINGS",
			font_title = self.fonts.title,
			title_offset_y = 32,
			sx = 3, sy = 3,

			middleButton = {
				id = "Back",
				normal = self.images.back,
				hovered = self.images.back_hovered,
				onClick = function()
					window:close()
				end
			},

			insideButton = {
				id = "Volume",
				normal = btn_volume,
				hovered = btn_volume_hovered,
				onClick = function(system, e)
					if data.data.volume == 1 then
						data.data.volume = 0
						system:changeSprite(e, resourceManager:getImage("button_mute"), resourceManager:getImage("button_mute_hovered"))
					else
						data.data.volume = 1
						system:changeSprite(e, resourceManager:getImage("button_volume"), resourceManager:getImage("button_volume_hovered"))
					end
					data:save()
				end
			}
		})
end

function Event:showLock()
	if not self:checkAssets() then return end
	opened_id = "Window_ShowLock"
	local spr_window = lume.randomchoice(self.gui)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_GetName", window,
		{
			spr_window = spr_window,
			str_title = "ALERT!",
			font_title = self.fonts.title,
			str_content = "This palette is unavailable due to only one week of development. It will be available soon!",
			font_content = self.fonts.content,

			button1 = {
				id = "Accept",
				normal = self.images.accept,
				hovered = self.images.accept_hovered,
				onClick = function()
					window:close()
				end
			},
		})
end

function Event:getName()
	if not self:checkAssets() then return end
	opened_id = "Window_GetName"
	local spr_window = lume.randomchoice(self.gui)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_GetName", window,
		{
			uncloseable = true,
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
					gamestate:send("saveName")
					window:close()
				end
			},

			textinput = {
				font = self.fonts.title,
			}
		})
end

function Event:showExitConfirmation()
	if not self:checkAssets() then return end
	opened_id = "Window_Exit"
	local spr_window = lume.randomchoice(self.gui)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_Exit", window,
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
	if not self:checkAssets() then return end
	opened_id = "Window_Home"
	local window = require("ecs.instances.window")
	local spr_window = lume.randomchoice(self.gui)
	gamestate:addInstance( "Window_Home", window,
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
	if opened_id then return false
	else
		if not self.gui then
			self.gui = {
				[1] = resourceManager:getImage("window_red"),
				[2] = resourceManager:getImage("window_green"),
				[3] = resourceManager:getImage("window_blue"),
			}
		end
		if not self.images then
			self.images = {
				accept = resourceManager:getImage("btn_accept"),
				accept_hovered = resourceManager:getImage("btn_accept_hovered"),
				back = resourceManager:getImage("btn_back"),
				back_hovered = resourceManager:getImage("btn_back_hovered"),
				cancel = resourceManager:getImage("btn_cancel"),
				cancel_hovered = resourceManager:getImage("btn_cancel_hovered"),
				window_settings = resourceManager:getImage("window_settings"),
			}
		end
		if not self.fonts then
			self.fonts = {
				title = resourceManager:getFont("upheaval_42"),
				content = resourceManager:getFont("upheaval_32"),
				button = resourceManager:getFont("upheaval_28"),
			}
		end
		return true
	end
end

function Event:reset()
	opened_id = nil
end

function Event:getIfOpened()
	return opened_id
end

return Event
