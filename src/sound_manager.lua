local SoundManager = {}
local resourceManager = require("src.resource_manager")
local data = require("src.data")
local lume = require("modules.lume.lume")

function SoundManager:check()
	if not self.sfx_hover then self.sfx_hover = resourceManager:getSource("sfx_hover1") end
	if not self.sfx_wrong then self.sfx_wrong = resourceManager:getSource("sfx_wrong") end
	if not self.sfx_forward then self.sfx_forward = resourceManager:getSource("sfx_forward") end
	if not self.sfx_back then self.sfx_back = resourceManager:getSource("sfx_back") end
	if not self.sfx_page_turn then self.sfx_page_turn = resourceManager:getSource("sfx_page_turn") end
	if not self.sfx_transition then self.sfx_transition = resourceManager:getSource("sfx_transition") end
	if not self.sfx_buy then self.sfx_buy = resourceManager:getSource("sfx_buy") end
	if not self.clicks then
		self.clicks = {
			resourceManager:getSource("sfx_click1"),
			-- resourceManager:getSource("sfx_click2"),
			resourceManager:getSource("sfx_click3"),
			resourceManager:getSource("sfx_click4"),
			resourceManager:getSource("sfx_click5"),
		}
	end
	if not self.coins then
		self.coins = {
			resourceManager:getSource("sfx_coins1"),
			resourceManager:getSource("sfx_coins2"),
			resourceManager:getSource("sfx_coins3"),
		}
	end
end

function SoundManager:send(event)
	if data.data.volume == 0 then return end
	self:check()
	if event == "guiOnEnter" then
		self.sfx_hover:play()
	elseif event == "guiOnExit" then
	elseif event == "guiOnClick" then
		if self.click and self.click:isPlaying() then self.click:stop() end
		self.click = lume.randomchoice(self.clicks)
		local r = math.random(50, 100)/100
		self.click:setVolume(r)
		self.click:play()
	elseif event == "lock" then
		self.sfx_wrong:play()
	elseif event == "forward" then
		self.sfx_forward:play()
	elseif event == "back" then
		self.sfx_back:play()
	elseif event == "page_turn" then
		self.sfx_page_turn:play()
	elseif event == "transition" then
		self.sfx_transition:play()
	elseif event == "buy" then
		self.sfx_buy:play()
	elseif event == "tapOnCat" then
		if self.coin and self.coin:isPlaying() then self.coin:stop() end
		self.coin = lume.randomchoice(self.coins)
		local r = math.random(50, 100)/100
		self.coin:setVolume(r)
		self.coin:play()
	end
end

return SoundManager
