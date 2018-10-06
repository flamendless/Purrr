local path = "ecs.entities."

local req = function(id)
	return require(path .. id)
end

local Entities = {
	button = req("button"),
}

return Entities
