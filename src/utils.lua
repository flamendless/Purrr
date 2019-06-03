local Utils = {}

function Utils:pointToRectCheck(px, py, x, y, w, h)
	return px > x and px < x + w and py > y and py < y + h
end


return Utils
