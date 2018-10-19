local path = "ecs.entities."

local req = function(id)
	return require(path .. id)
end

local Entities = {
	scene = req("scene"),
	color_picker = req("color_picker"),
}

return Entities
