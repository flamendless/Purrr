local Colors = {}

local convert = function(r, g, b) return { r/255, g/255, b/255 } end

local lookup = {
	white = { 1, 1, 1 },
	black = { 0, 0, 0 },
	red = { 1, 0, 0 },
	green = { 0, 1, 0 },
	blue = { 0, 0, 1 },
}

--FLAT COLORS (https://www.materialui.co/flatuicolors)
local flat_colors = {
	white = {
		light = convert(236, 240, 241), --clouds
		dark = convert(189, 195, 199), --silver
	},
	black = {
		light = convert(52, 73, 94), --wetasphalt
		dark = convert(44, 62, 80), --midnight
	},
	teal = {
		light = convert(26, 188, 156), --turquoise
		dark = convert(22, 160, 133), --greensea
	},
	green = {
		light = convert(46, 204, 113), --emerland
		dark = convert(39, 174, 96), --nephritis
	},
	blue = {
		light = convert(52, 152, 219), --peterriver
		dark = convert(41, 128, 185), --belizehole
	},
	violet = {
		light = convert(155, 89, 182), --amethyst
		dark = convert(155, 89, 182), --wisteria
	},
	yellow = {
		light = convert(241, 196, 15), --sunflower
		dark = convert(243, 156, 18), --orange
	},
	orange = {
		light = convert(230, 126, 34), --carrot
		dark = convert(211, 84, 0), --pumpkin
	},
	red = {
		light = convert(231, 76, 60), --alazarin
		dark = convert(192, 57, 43), --pomegranate
	},
	gray = {
		light = convert(149, 165, 166), --concrete
		dark = convert(127, 140, 141), --asbestos
	}
}

local mt = {
	__index = Colors,
	__call = function(self, ...)
		if type(...) == "string" then
			if ... == "flat" then
				return Colors.flat(...)
			else
				return Colors.str(...)
			end
		elseif type(...) == "number" then
			return Colors.num(...)
		end
	end
}

function Colors.str(str, a)
	local t = { unpack(lookup[str]) }
	t[4] = a or 1
	return setmetatable(t, mt)
end

function Colors.num(r, g, b, a)
	local t = { r, g, b, a or 1 }
	return setmetatable(t, mt)
end

function Colors.flat(_, str, variation, a)
	local t = { unpack(flat_colors[str][variation]) }
	t[4] = a or 1
	return setmetatable(t, mt)
end

function Colors:set() love.graphics.setColor(unpack(self)) end
function Colors:setBG() love.graphics.setBackgroundColor(unpack(self)) end

setmetatable(Colors, mt)

return Colors
