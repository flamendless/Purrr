local Event = {}
local C = require("ecs.components")

local transition = require("src.transition")
local resourceManager = require("src.resource_manager")
local soundManager = require("src.sound_manager")
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

function Event:setup()
	self.windows = {
		resourceManager:getImage("window_red"),
		resourceManager:getImage("window_green"),
		resourceManager:getImage("window_blue"),
	}
	self.images = {
		accept = resourceManager:getImage("button_accept"),
		accept_hovered = resourceManager:getImage("button_accept_hovered"),
		cancel = resourceManager:getImage("button_cancel"),
		cancel_hovered = resourceManager:getImage("button_cancel_hovered"),
		back = resourceManager:getImage("button_back"),
		back_hovered = resourceManager:getImage("button_back_hovered"),
		items_base = resourceManager:getImage("items_base"),
		items_base_hovered = resourceManager:getImage("items_base_hovered"),
	}

	self.fonts = {
		title = resourceManager:getFont("upheaval_42"),
		content = resourceManager:getFont("upheaval_36"),
		items = resourceManager:getFont("trashhand_32")
	}

	self.settings = {
		resourceManager:getImage("window_settings1"),
		resourceManager:getImage("window_settings2"),
		resourceManager:getImage("window_settings3"),
	}
end

function Event:showStore()
	if opened_id then return end
	opened_id = "Window_ShowStore"
	local spr_window = lume.randomchoice(self.windows)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_ShowStore", window,
		{
			spr_window = spr_window,
			str_title = "STORE",
			font_title = self.fonts.title,

			middleButton = {
				id = "Back",
				normal = self.images.back,
				hovered = self.images.back_hovered,
				onClick = function()
					window:close()
				end
			},

			insideButton = {
				id = "item_walk",
				normal = self.images.items_base,
				hovered = self.images.items_base_hovered,
				text = "WALK pp1000",
				font = self.fonts.items,
				color = colors("white"),
				onClick = function(system, e)
					gamestate:getCurrent():buy(e, "walk", 1000)
				end
			},

			insideButton2 = {
				id = "item_jump",
				normal = self.images.items_base,
				hovered = self.images.items_base_hovered,
				text = "JUMP pp2000",
				font = self.fonts.items,
				onClick = function(system, e)
					gamestate:getCurrent():buy(e, "jump", 2000)
				end
			},

			insideButton3 = {
				id = "item_attack",
				text = "ATTACK pp3000",
				font = self.fonts.items,
				normal = self.images.items_base,
				hovered = self.images.items_base_hovered,
				onClick = function(system, e)
					gamestate:getCurrent():buy(e, "attack", 3000)
				end
			},
		})
end

function Event:showCatInfo()
	if opened_id then return end
	opened_id = "Window_ShowCatInfo"
	local spr_window = lume.randomchoice(self.settings)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_ShowCatInfo", window,
		{
			spr_window = spr_window,
			str_title = "YOUR CAT",
			font_title = self.fonts.title,
			title_offset_y = 32,
			str_content = ("NAME: %s\nCOLOUR: %s"):format(data.data.cat_name, data.data.palette),
			content_offset_y = 128,
			sx = 3, sy = 3,

			middleButton = {
				id = "Back",
				normal = self.images.back,
				hovered = self.images.back_hovered,
				onClick = function()
					window:close()
				end
			},
		})
end

function Event:showEnergyInfo()
	if opened_id then return end
	opened_id = "Window_ShowEnergy"
	local spr_window = lume.randomchoice(self.settings)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_ShowEnergyInfo", window,
		{
			spr_window = spr_window,
			str_title = "ENERGY",
			font_title = self.fonts.title,
			title_offset_y = 32,
			str_content = ("ENERGY: %s"):format(data.data.energy),
			content_offset_y = 128,
			sx = 3, sy = 3,

			middleButton = {
				id = "Back",
				normal = self.images.back,
				hovered = self.images.back_hovered,
				onClick = function()
					window:close()
				end
			},
		})
end

function Event:showSettings()
	if opened_id then return end
	opened_id = "Window_ShowSettings"
	local btn_volume, btn_volume_hovered
	if data.data.volume == 1 then
		btn_volume = resourceManager:getImage("button_volume")
		btn_volume_hovered = resourceManager:getImage("button_volume_hovered")
	elseif data.data.volume == 0 then
		btn_volume = resourceManager:getImage("button_mute")
		btn_volume_hovered = resourceManager:getImage("button_mute_hovered")
	end
	local spr_window = lume.randomchoice(self.settings)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_ShowSettings", window,
		{
			spr_window = spr_window,
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
			},

			insideButton2 = {
				id = "Star",
				normal = resourceManager:getImage("button_star"),
				hovered = resourceManager:getImage("button_star_hovered"),
				onClick = function()
					love.system.openURL(data.dev.playstore)
				end
			},

			insideButton3 = {
				id = "Twitter",
				normal = resourceManager:getImage("button_twitter"),
				hovered = resourceManager:getImage("button_twitter_hovered"),
				onClick = function()
					love.system.openURL(data.dev.twitter)
				end
			},
		})
end

function Event:showLock(msg)
	if opened_id then return end
	opened_id = "Window_ShowLock"
	local spr_window = lume.randomchoice(self.windows)
	local window = require("ecs.instances.window")
	gamestate:addInstance( "Window_ShowLock", window,
		{
			spr_window = spr_window,
			str_title = "ALERT!",
			font_title = self.fonts.title,
			str_content = msg or "This palette is unavailable due to only one week of development. It will be available soon!",
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
	if opened_id then return end
	opened_id = "Window_GetName"
	local spr_window = lume.randomchoice(self.windows)
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
	if opened_id then return end
	opened_id = "Window_Exit"
	local spr_window = lume.randomchoice(self.windows)
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
					transition.color = colors("black")
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

function Event:showHomeConfirmation(arg)
	if opened_id then return end
	opened_id = "Window_Home"
	local window = require("ecs.instances.window")
	local spr_window = lume.randomchoice(self.windows)
	local str_content = "Are you sure you want to return to menu screen?"
	if arg == "lobby" then
		str_content = "Are you sure you want to return to lobby?"
	end
	gamestate:addInstance( "Window_Home", window,
		{
			spr_window = spr_window,
			str_title = "CONFIRMATION",
			font_title = self.fonts.title,
			str_content = str_content,
			font_content = self.fonts.content,
			button1 = {
				id = "Accept",
				normal = self.images.accept,
				hovered = self.images.accept_hovered,
				onClick = function()
					window:close()
					if arg == "lobby" then
						transition:start( require("states.lobby") )
					else
						transition:start( require("states.menu") )
					end
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

function Event:reset()
	opened_id = nil
end

function Event:getIfOpened()
	return opened_id
end

return Event
