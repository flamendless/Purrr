local ResourceManager = {
	__assets = { images = {}, fonts = {} },
	__ref = {}
}

function ResourceManager:add(kind, id, data)
	self.__assets[kind][id] = data
end

function ResourceManager:check(kind, id)
	return self.__assets[kind][id]
end

function ResourceManager:getImage(id)
	assert(self.__assets.images[id], ("Image %s does not exist!"):format(id))
	self.__ref.images[id] = self.__ref.images[id] + 1
	return self.__assets.images[id]
end

function ResourceManager:getFont(id)
	assert(self.__assets.fonts[id], ("Font %s does not exist!"):format(id))
	self.__ref.fonts[id] = self.__ref.fonts[id] + 1
	return self.__assets.images[id]
end

return ResourceManager
