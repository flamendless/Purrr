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
local config = require("src.config")
local bgm = require("src.bgm")
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
		config = true,
		lines = true,
		selected = false,
		components = false,
	},
}

local stats = {}
local flags = {"ImGuiWindowFlags_AlwaysAutoResize"}
local flags_tree = {"ImGuiTreeNodeFlags_DefaultOpen"}
local flag_mute = false
local temp_flag_mute = flag_mute
local master_volume = 1

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
	if self.windows.config then self:drawConfig() end
	if self.show_demo then imgui.ShowDemoWindow(self.show_demo) end
	if self.windows.lines then
		self.colors.line:set()
		love.graphics.line(0, screen.y/2, screen.x, screen.y/2) --middle-horizontal
		love.graphics.line(screen.x/2, 0, screen.x/2, screen.y) --middle-vertical
		love.graphics.line(0, screen.pad, screen.x, screen.pad) --top
		love.graphics.line(0, screen.y - screen.pad, screen.x, screen.y - screen.pad) --bottom
		love.graphics.line(screen.pad, 0, screen.pad, screen.y) --left
		love.graphics.line(screen.x - screen.pad, 0, screen.x - screen.pad, screen.y) --right
	end
	self:drawMedia()
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
			self.windows.config = imgui.Checkbox("Config", self.windows.config)
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

function Debug:drawConfig()
	imgui.Begin("Config", nil, flags)
	for k, v in pairs(config.data) do
		if k ~= "dev" then
			if imgui.TreeNode(tostring(k)) then
				for str, val in pairs(v) do
					imgui.Text(string.format("%s : %s", str, val))
				end
				imgui.TreePop()
			end
		end
	end
	if imgui.TreeNode("more") then
		imgui.Text("Path: " .. config.filename)
		imgui.Text("Filename: " .. config.path)
		imgui.TreePop()
	end
	imgui.Separator()
	if imgui.Button("Delete Config File") then
		config:erase()
	end
	imgui.End()
end

function Debug:drawInfo()
	imgui.Begin("Info", nil, flags)
	imgui.Text("GAME TITLE: " .. love.window.getTitle())
	imgui.Text("GAME SIZE: " .. ("%ix%i"):format(love.graphics.getDimensions()))
	imgui.Text("GAMESTATE: " .. gamestate:getCurrentID())
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
	if self.selected:has(C.tag) then
		local c_tag = self.selected[C.tag]
		c_tag:debug()
		imgui.Separator()
	end
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
		imgui.Separator()
	end
	for _, c_id in ipairs(self.components) do
		if not (c_id == "tag") then
			if self.selected:has(C[c_id]) then
				local c = self.selected[C[c_id]]
				if c.debug then c:debug() end
			end
		end
	end

	imgui.End()
end

function Debug:drawMedia()
	imgui.Begin("Media", nil, flags)
	local title = ""
	local pos = 0
	local duration = 0
	if bgm.data.title then title = bgm.data.title end
	if bgm.data.pos then pos = bgm.data.pos end
	if bgm.data.duration then duration = bgm.data.duration end
	imgui.Text(title)
	local v, status = imgui.SliderFloat("##slider", pos, 0, duration)
	imgui.Text(string.format("%.2f : %.2f", pos, duration))
	if status then
		if bgm.current then bgm.current:seek(v, "seconds") end
	end
	if imgui.Button("Play") then
		if bgm.current then bgm.current:play() end
	end
	imgui.SameLine()
	if imgui.Button("Pause") then
		if bgm.current then bgm.current:pause() end
	end
	imgui.SameLine()
	if imgui.Button("Stop") then
		if bgm.current then bgm.current:stop() end
	end
	imgui.SameLine()
	flag_mute = imgui.Checkbox("Mute", flag_mute)
	if flag_mute ~= temp_flag_mute then
		if master_volume == 1 then
			master_volume = 0
		else
			master_volume = 1
		end
		love.audio.setVolume(master_volume)
		temp_flag_mute = flag_mute
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
