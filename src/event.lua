local Event = {}

function Event.showExitConfirmation()
	local title = "Confirmation"
	local message = "Are you sure you want to quit the game?"
	local buttons = {"OK", "No!", escapebutton = 2}
	local pressedbutton = love.window.showMessageBox(title, message, buttons)
	if pressedbutton == 1 then
		love.event.quit()
	end
end

return Event
