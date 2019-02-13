local ResourceManager = {
	__assets = { images = {}, fonts = {}, ImageData = {}, sources = {} },
	__persistent = {},
	__font_cache = {},
	__ref = {},
}

function ResourceManager:getPersistent(id)
	return self.__persistent[id]
end

function ResourceManager:add(kind, id, data, container)
	if kind == "fonts" then
		local index = id:match("^.*()_")
		local str = id:sub(1, index-1)
		self.__font_cache[str] = true
	end

	if container == "Base" then
		self.__persistent[id] = data
	else
		self.__assets[kind][id] = data
	end
end

function ResourceManager:flush()
	for _, kind in pairs(self.__assets) do
		for k, v in pairs(kind) do
			kind[k] = nil
		end
	end
end

function ResourceManager:check(kind, id)
	if kind == "fonts" then
		return self.__font_cache[id]
	else
		return self.__assets[kind][id]
	end
end

function ResourceManager:getImage(id)
	assert(self.__assets.images[id], ("Image %s does not exist!"):format(id))
	self:addRef(id)
	return self.__assets.images[id]
end

function ResourceManager:getFont(id)
	assert(self.__assets.fonts[id], ("Font %s does not exist!"):format(id))
	self:addRef(id)
	return self.__assets.fonts[id]
end

function ResourceManager:getSource(id)
	assert(self.__assets.sources[id], ("Sound %s does not exist!"):format(id))
	self:addRef(id)
	return self.__assets.sources[id]
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

function ResourceManager:addRef(id)
	if not self.__ref[id] then
		self.__ref[id] = 0
	end
	self.__ref[id] = self.__ref[id] + 1
end

function ResourceManager:getRef()
	return self.__ref
end

function ResourceManager:setFilter()
	for k,v in pairs(self.__assets) do
		if k == "images" or k == "fonts" then
			for n,m in pairs(v) do
				m:setFilter(__filter, __filter)
			end
		end
	end
end

return ResourceManager
