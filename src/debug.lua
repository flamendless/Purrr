local lurker = require("modules.lurker.lurker")
local flux = require("modules.flux.flux")
local log = require("modules.log.log")
local inspect = require("modules.inspect.inspect")
local semver = require("modules.semver.semver")
local screen = require("src.screen")
local time = require("src.time")
local colors = require("src.colors")
local preload = require("src.preload")
local transition = require("src.transition")
local gamestate = require("src.gamestate")
local resourceManager = require("src.resource_manager")
local utils = require("src.utils")

local C = require("ecs.components")

local Debug = {
	components = nil,
	selected = nil,
	showAll = false,
	show_demo = false,
	colors = {},
	font = love.graphics.newFont(12),
	windows = {
		info = true,
		collisions = true,
		lines = true,
		selected = false,
		components = false,
	},
}

local stats = {}
local flags = {"ImGuiWindowFlags_AlwaysAutoResize"}
local flags_tree = {"ImGuiTreeNodeFlags_DefaultOpen"}

lurker.preswap = function(filename)
	return filename == "save.lua"
end

lurker.postswap = function(filename)
	log.trace("Swapped: " .. filename)
	gamestate:reload()
end

function Debug:init()
	self.colors.line = colors(1, 0, 0, 0.5)
	self.showAll = true
end

function Debug:update(dt)
	if not (love.system.getOS() == "Android") then lurker.update(dt) end
	if not self.showAll then
		return
	end
	imgui.NewFrame()
end

function Debug:draw()
	if not self.showAll then
		return
	end
	self:drawMenuBar()
	if self.windows.info then self:drawInfo() end
	if self.windows.selected then self:drawSelected() end
	if self.windows.components then self:drawComponents() end
	if self.show_demo then imgui.ShowDemoWindow(self.show_demo) end
	if self.windows.lines then
		self.colors.line:set()
		love.graphics.line(0, screen.y/2, screen.x, screen.y/2) --middle-horizontal
		love.graphics.line(screen.x/2, 0, screen.x/2, screen.y) --middle-vertical
		love.graphics.line(0, 32, screen.x, 32) --top
		love.graphics.line(0, screen.y - 32, screen.x, screen.y - 32) --bottom
		love.graphics.line(32, 0, 32, screen.y) --left
		love.graphics.line(screen.x - 32, 0, screen.x - 32, screen.y) --right
	end
	love.graphics.setColor(1, 1, 1, 1)
	imgui.Render()
	stats = love.graphics.getStats(stats)
end

function Debug:drawMenuBar()
	if imgui.BeginMainMenuBar() then
		if imgui.BeginMenu("Game") then
			if imgui.MenuItem("Restart") then gamestate:restartCurrent() end
			if imgui.MenuItem("Exit") then love.event.quit() end
			imgui.EndMenu()
		end
		if imgui.BeginMenu("View") then
			self.windows.info = imgui.Checkbox("Info", self.windows.info)
			self.windows.collisions = imgui.Checkbox("Collisions", self.windows.collisions)
			self.windows.lines = imgui.Checkbox("Lines", self.windows.lines)
			imgui.EndMenu()
		end
		if imgui.BeginMenu("Help") then
			imgui.Text("Press F5 to toggle debug view")
			imgui.Text("Press F6 to toggle demo view")
			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end
end

function Debug:drawInfo()
	imgui.Begin("Info", nil, flags)
	imgui.Text("GAME TITLE: " .. love.window.getTitle())
	imgui.Text("GAME SIZE: " .. ("%ix%i"):format(love.graphics.getDimensions()))
	imgui.Text("FPS:" .. love.timer.getFPS())
	if stats.drawcalls then
		if imgui.TreeNodeEx("more", flags_tree) then
			imgui.Text("CANVASES: " .. stats.canvases)
			imgui.Text("CANVAS SWITCHES: " .. stats.canvasswitches)
			imgui.Text("DRAW CALLS: " .. stats.drawcalls)
			imgui.Text("DRAW CALLS BATCHED: " .. stats.drawcallsbatched)
			imgui.Text("FONTS: " .. stats.fonts)
			imgui.Text("IMAGES: " .. stats.images)
			imgui.Text("SHADER SWITCHES: " .. stats.shaderswitches)
			imgui.Text("TEXTURE MEMORY: " .. stats.texturememory)
			imgui.TreePop()
		end
	end
	imgui.End()
end

function Debug:drawComponents()
	imgui.Begin("Components", nil, flags)
	for _, c_id in ipairs(self.components) do
		imgui.Text(c_id)
	end
	imgui.End()
end

function Debug:drawSelected()
	imgui.Begin("Entity", nil, flags)
	--TAG
	if self.selected:has(C.tag) then
		local c_tag = self.selected[C.tag]
		c_tag:debug()
	end

	--TRANSFORM
	if self.selected:has(C.transform) then
		local c_transform = self.selected[C.transform]
		c_transform:debug()
	end

	--COLOR
	if self.selected:has(C.color) then
		local c_color = self.selected[C.color]
		c_color:debug()
	end

	--SPRITE
	if self.selected:has(C.sprite) then
		local c_sprite = self.selected[C.sprite]
		c_sprite:debug()
	end
	imgui.End()
end

function Debug:keypressed(key)
	if key == "`" then
		self.showAll = not self.showAll
	elseif key == "f5" then
		self:toggleEditorView()
	elseif key == "f6" then
		self:toggleDemoView()
	end
	imgui.KeyPressed(key)
end

function Debug:toggleEditorView() self.showAll = not self.showAll end
function Debug:toggleDemoView() self.show_demo = not self.show_demo end
function Debug:keyreleased(key) imgui.KeyReleased(key) end
function Debug:textinput(t) imgui.TextInput(t) end
function Debug:mousepressed(mx, my, mb) imgui.MousePressed(mb) end
function Debug:mousereleased(mx, my, mb) imgui.MouseReleased(mb) end
function Debug:mousemoved(mx, my) imgui.MouseMoved(mx, my) end
function Debug:wheelmoved(x, y) imgui.WheelMoved(y) end
function Debug:quit() imgui.ShutDown() end

function Debug:onEntitySelect(e)
	self.selected = e
	self.windows.selected = true
	self.windows.components = true
	self.components = {}
	for c_id, component in pairs(C) do
		if e:has(component) then
			table.insert(self.components, c_id)
		end
	end
end

return Debug
