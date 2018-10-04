local ResourceManager = {
	__assets = { images = {}, fonts = {}, ImageData = {} },
	__ref = {},
}

function ResourceManager:add(kind, id, data)
	self.__assets[kind][id] = data
end

function ResourceManager:check(kind, id)
	return self.__assets[kind][id]
end

function ResourceManager:getImage(id)
	assert(self.__assets.images[id], ("Image %s does not exist!"):format(id))
	self:addRef(id)
	return self.__assets.images[id]
end

function ResourceManager:getAll(kind)
	assert(self.__assets[kind], ("%s Does not exist!"):format(kind))
	local t = {}
	for id, data in pairs(self.__assets[kind]) do
		t[id] = data
		self:addRef(id)
	end
	return t
end

function ResourceManager:getFont(id)
	assert(self.__assets.fonts[id], ("Font %s does not exist!"):format(id))
	self:addRef(id)
	return self.__assets.images[id]
end

function ResourceManager:addRef(id)
	if not self.__ref[id] then
		self.__ref[id] = 0
	end
	self.__ref[id] = self.__ref[id] + 1
end

return ResourceManager
