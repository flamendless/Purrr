local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")
local Draft = require("modules.draft.draft")
local draft = Draft()
local inspect = require("modules.inspect.inspect")

local index = 1
local dur = 1
local ease = "quadin"
local _font = love.graphics.newFont(12)
local total, done

local ShapeTransform = System({
		C.shapeTransform,
		C.transformingPoints,
	}, {
		C.shapeTransform,
		C.transformingPoints,
		C.points,
		"points"
	})

local shape = {
	{ size = 128, seg = 64 },
	{ size = 96, seg = 32 },
	{ size = 72, seg = 16 },
	{ size = 64, seg = 8 },
	{ size = 48, seg = 4 },
}

local tableCopy = function(t)
	local copy = {}
	for k,v in pairs(t) do copy[k] = v end
	return copy
end

function ShapeTransform:entityAddedTo(e, pool)
	if pool.name == "points" then
		self:onStart(e)
	else
		local c_points = e[C.transformingPoints]
		c_points.points = {}
		for i = 1, #shape do
			c_points.points[i] = draft:circle(0, 0, shape[i].size, shape[i].seg, "line")
		end
		dur = e[C.shapeTransform].dur
		if e:has(C.ease) then
			ease = e[C.ease].ease
		end
		e:give(C.points, tableCopy(c_points.points[1])):apply()
	end
end

function ShapeTransform:onStart(e)
	local c_shapeTransform = e[C.shapeTransform]
	local c_tp = e[C.transformingPoints]
	local c_points = e[C.points]

	index = index + 1
	if index > #c_tp.points then
		local reversed = {}
		local n = 1
		for i = #c_tp.points, 1, -1 do
			reversed[n] = c_tp.points[i]
			n = n + 1
		end
		c_tp.points = reversed
		index = 1
	end
	local current = c_points.points
	local after = c_tp.points[index]
	if after then
		self:processPoints(current, after)
		self:getInstance():emit("change", e, dur)
	end
end

function ShapeTransform:update(dt)
	if done ~= 0 and total ~= 0 and done == total then
		done = 0
		total = 0
		local e
		for i = 1, self.points.size do
			e = self.pool:get(i)
			local c_tp = e[C.transformingPoints]
			e:remove(C.points):apply()
			e:give(C.points, tableCopy(c_tp.points[index])):apply()
		end
	end
end

function ShapeTransform:draw()
	local e
	for i = 1, self.points.size do
		e = self.points:get(i)
		local c_debug = e[C.debug]
		if c_debug then
			local c_points = e[C.points]
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.setFont(_font)
			-- for i = 1, #c_points.current, 2 do
			-- 	local x = c_points.current[i]
			-- 	local y = c_points.current[i + 1]
			-- 	love.graphics.print(("%i, %i"):format(i, i + 1), x, y)
			-- end
			-- for i = 1, #c_points.points[2], 2 do
			-- 	local x = c_points.points[2][i]
			-- 	local y = c_points.points[2][i + 1]
			-- 	love.graphics.print(("%i, %i"):format(i, i + 1), x, y)
			-- end
		end
	end
end

function ShapeTransform:processPoints(current, after)
	total = #current/2
	done = 0
	local d = #current/#after * 2
	local n = 1
	local excess = {}
	for i = 1, #current, 2 do
		if (i % d) == 1 then
			flux.to(current, dur, { [i] = after[n], [i+1] = after[n+1] })
				:ease(ease)
				:oncomplete(function() done = done + 1 end)
			n = n + 2
		else
			excess[#excess + 1] = { i, i + 1 }
		end
	end

	local _current, _prev
	local n = 1
	for i = 1, #after, 2 do
		_current = { i, i + 1 }
		_prev = { _current[1], _current[2] }
		local x = after[_current[1]]
		local y = after[_current[2]]
		local x2 = after[_prev[1]]
		local y2 = after[_prev[2]]
		if excess[n] then
			flux.to(current, dur, { [excess[n][1]] = (x+x2)/2, [excess[n][2]] = (y+y2)/2 })
				:ease(ease)
				:oncomplete(function() done = done + 1 end)
			n = n + 1
		end
	end
end


return ShapeTransform
