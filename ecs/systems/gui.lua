local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local utils = require("src.utils")

local GUI = System({
		C.gui_button,
		C.transform,
		C.sprite,
		"button"
	})

function GUI:update(dt)
	for _, e in ipairs(self.button) do
		local c_button = e[C.gui_button]
		local c_transform = e[C.transform]
		local c_sprite = e[C.sprite].sprite
		local c_onHoveredSprite = e[C.onHoveredSprite]
		local onMouseEnter = utils:checkOnMouseEnter(e)
		if onMouseEnter then
			if not c_button.state.isEntered then
				c_button.state.isEntered = true
				if c_onHoveredSprite then
					c_onHoveredSprite.isActive = true
				end
			end
		else
			c_button.state.isEntered = false
			if c_onHoveredSprite then
				c_onHoveredSprite.isActive = false
			end
		end
	end
end

function GUI:mousepressed(mx, my, mb)
	for _, e in ipairs(self.button) do
		local c_button = e[C.gui_button]
		local c_onClick = e[C.gui_onClick]
		if c_onClick and mb == 1 and c_button.state.isEntered then
			c_onClick.callback()
		end
	end
end

--TODO: add touchpressed

return GUI
