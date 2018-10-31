local Event = {}
local C = require("ecs.components")
local ecs = {
	instance = require("modules.concord.lib.instance"),
	entity = require("modules.concord.lib.entity"),
}

local transition = require("src.transition")
local resourceManager = require("src.resource_manager")
local soundManager = require("src.sound_manager")
local gamestate = require("src.gamestate")
local colors = require("src.colors")
local screen = require("src.screen")
local data = require("src.data")
local pos = require("src.positions")
local lume = require("modules.lume.lume")
local inspect = require("modules.inspect.inspect")

function Event:init()
	self.colors = { cover = colors("flat", "black", "dark", 0.8) }
	self.isOpen = false
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
	self.isOpen = true
	local str = "????"
	if data.data.cat_name then str = data.data.cat_name end
	local instance = gamestate:getCurrent().instance
	local E = require("ecs.entities")
	local spr_windows = {
		resourceManager:getImage("window_red"),
		resourceManager:getImage("window_blue"),
		resourceManager:getImage("window_green"),
	}
	local spr_window = lume.randomchoice(spr_windows)
	local window = E.window(ecs.entity(), spr_window,
		(screen.x - pos.window.title_pad)/spr_window:getWidth(),
		(screen.y - pos.window.title_pad)/spr_window:getHeight())
	local title = E.window_title(ecs.entity(), window, "Enter Cat's Name:")
	local textinput = E.textinput(ecs.entity(), window, str)
	local blur = E.blur(ecs.entity(), window)
	local accept = E.button_accept(ecs.entity(), window, true)
		:give(C.onClick, function()
				instance:emit("close")
				local text = textinput[C.textinput].buffer
				data.data.cat_name = text
				data.data.got_name = true
				data:save()
			end)
		:give(C.onUpdate, function(e)
				local text = textinput[C.textinput].buffer
				if text then
					if #text >= 3 then e[C.state].isDisabled = false
					else e[C.state].isDisabled = true
					end
				end
			end)
		:apply()
	local cancel = E.button_cancel(ecs.entity(), window)
		:give(C.onClick, function() instance:emit("close") end)
		:apply()
	instance:addEntity(blur)
	instance:addEntity(window)
	instance:addEntity(title)
	instance:addEntity(textinput)
	instance:addEntity(accept)
end

function Event:showExitConfirmation()
	self.isOpen = true
	local instance = gamestate:getCurrent().instance
	local E = require("ecs.entities")
	local spr_windows = {
		resourceManager:getImage("window_red"),
		resourceManager:getImage("window_blue"),
		resourceManager:getImage("window_green"),
	}
	local spr_window = lume.randomchoice(spr_windows)
	local window = E.window(ecs.entity(), spr_window,
		(screen.x - pos.window.title_pad)/spr_window:getWidth(),
		(screen.y - pos.window.title_pad)/spr_window:getHeight())
	local accept = E.button_accept(ecs.entity(), window)
		:give(C.onClick, function()
			instance:emit("close")
			transition:start(function() love.event.quit() end)
		end)
		:apply()
	local cancel = E.button_cancel(ecs.entity(), window)
		:give(C.onClick, function() instance:emit("close") end)
		:apply()
	local title = E.window_title(ecs.entity(), window, "Confirmation")
	local body = E.window_body(ecs.entity(), window, "Are you sure you want to quit the game?")
	local blur = E.blur(ecs.entity(), window)
	instance:addEntity(blur)
	instance:addEntity(window)
	instance:addEntity(accept)
	instance:addEntity(cancel)
	instance:addEntity(title)
	instance:addEntity(body)
end

function Event:showEraseConfirmation()
	self.isOpen = true
	local instance = gamestate:getCurrent().instance
	local E = require("ecs.entities")
	local spr_windows = {
		resourceManager:getImage("window_red"),
		resourceManager:getImage("window_blue"),
		resourceManager:getImage("window_green"),
	}
	local spr_window = lume.randomchoice(spr_windows)
	local window = E.window(ecs.entity(), spr_window,
		(screen.x - pos.window.title_pad)/spr_window:getWidth(),
		(screen.y - pos.window.title_pad)/spr_window:getHeight())
	local accept = E.button_accept(ecs.entity(), window)
		:give(C.onClick, function()
			instance:emit("close")
			data:erase()
		end)
		:apply()
	local cancel = E.button_cancel(ecs.entity(), window)
		:give(C.onClick, function() instance:emit("close") end)
		:apply()
	local title = E.window_title(ecs.entity(), window, "Confirmation")
	local body = E.window_body(ecs.entity(), window, "Are you sure you want to reset your data?")
	local blur = E.blur(ecs.entity(), window)
	instance:addEntity(blur)
	instance:addEntity(window)
	instance:addEntity(accept)
	instance:addEntity(cancel)
	instance:addEntity(title)
	instance:addEntity(body)
end

function Event:showSettings()
	self.isOpen = true
	local instance = gamestate:getCurrent().instance
	local E = require("ecs.entities")
	local spr_windows = {
		resourceManager:getImage("window_settings1"),
		resourceManager:getImage("window_settings2"),
		resourceManager:getImage("window_settings3"),
		resourceManager:getImage("window_settings4"),
	}
	local spr_window = lume.randomchoice(spr_windows)
	local window = E.window(ecs.entity(), spr_window, 3, 3)
	local blur = E.blur(ecs.entity(), window)
	local button_back = E.button_back(ecs.entity(), window)
		:give(C.onClick, function() gamestate:getCurrent().instance:emit("close") end)
		:apply()
	local button_volume = E.button_volume(ecs.entity(), window)
	local button_twitter = E.button_twitter(ecs.entity(), window)
	local button_erase = E.button_erase(ecs.entity(), window)

	instance:addEntity(blur)
	instance:addEntity(window)
	instance:addEntity(button_volume)
	instance:addEntity(button_twitter)
	instance:addEntity(button_erase)
	instance:addEntity(button_back)
end

function Event:showLobby(arg)
	self.isOpen = true
	local instance = gamestate:getCurrent().instance
	local E = require("ecs.entities")
	local spr_windows = {
		resourceManager:getImage("window_red"),
		resourceManager:getImage("window_blue"),
		resourceManager:getImage("window_green"),
	}
	local spr_window = lume.randomchoice(spr_windows)
	local window = E.window(ecs.entity(), spr_window,
		(screen.x - pos.window.title_pad)/spr_window:getWidth(),
		(screen.y - pos.window.title_pad)/spr_window:getHeight())
	local accept = E.button_accept(ecs.entity(), window)
		:give(C.onClick, function()
			instance:emit("close")
			transition:start(require("states.menu"))
		end)
		:apply()
	local cancel = E.button_cancel(ecs.entity(), window)
		:give(C.onClick, function() instance:emit("close") end)
		:apply()
	local title = E.window_title(ecs.entity(), window, "Confirmation")
	local body = E.window_body(ecs.entity(), window, "Are you sure you want to return to lobby?")
	local blur = E.blur(ecs.entity(), window)
	instance:addEntity(blur)
	instance:addEntity(window)
	instance:addEntity(accept)
	instance:addEntity(cancel)
	instance:addEntity(title)
	instance:addEntity(body)
end

function Event:drawCover()
	self.colors.cover:set()
	love.graphics.rectangle("fill", 0, 0, screen.x, screen.y)
end

function Event:getIfOpened() return opened_id end

return Event
