local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")
local Draft = require("modules.draft.draft")
local draft = Draft()
local inspect = require("modules.inspect.inspect")

local dur = 1
local ShapeTransform = System({
		C.shapeTransform,
		C.points,
	})
local _font = love.graphics.newFont(12)
local total, done

function ShapeTransform:init()
	self.current = nil
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
		flux.to(current, dur, { [excess[n][1]] = (x+x2)/2, [excess[n][2]] = (y+y2)/2 })
			:oncomplete(function() done = done + 1 end)
		n = n + 1
	end
end

function ShapeTransform:entityAdded(e)
	self:onStart(e)
end

function ShapeTransform:onStart(e)
	local c_shapeTransform = e[C.shapeTransform]
	local c_points = e[C.points]

	if c_points.index < #c_points.points then
		local current = c_points.current
		local after = c_points.points[c_points.index + 1]
		self:processPoints(current, after)
		self.current = e
		self:getInstance():emit("change", e, dur)
	else
		e:give(C.spin, 64):apply()
	end
end

function ShapeTransform:update(dt)
	if done ~= 0 and total ~= 0 and done == total then
		done = 0
		total = 0
		local e
		for i = 1, self.pool.size do
			e = self.pool:get(i)
			local c_shapeTransform = e[C.shapeTransform]
			local c_points = e[C.points]
			if c_points.index < #c_points.points then
				c_points.index = c_points.index + 1
				c_points.current = c_points.points[c_points.index]
				self:onStart(e)
			end
		end
	end
end

function ShapeTransform:draw()
	local e
	for i = 1, self.pool.size do
		e = self.pool:get(i)
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

return ShapeTransform
