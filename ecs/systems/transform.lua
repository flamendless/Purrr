local System = require("modules.concord.lib.system")
local C = require("ecs.components")
local flux = require("modules.flux.flux")
local lume = require("modules.lume.lume")

local Transform = System({
		C.transform,
		C.sprite,
		"sprite"
	}, {
		C.transform,
		C.anim,
		"anim"
	}, {
		C.offset,
		"offset"
	})

function Transform:entityAddedTo(e, pool)
	if pool.name == "sprite" then
		self:handleSprite(e)
	elseif pool.name == "anim" then
		self:handleAnim(e)
	elseif pool.name == "offset" then
		self:handleOffset(e)
	end
end

function Transform:handleSprite(e)
	local c_sprite = e[C.sprite].sprite
	local c_transform = e[C.transform]
	if c_transform.ox == "center" then
		c_transform.ox = c_sprite:getWidth()/2
	elseif c_transform.ox == "right" then
		c_transform.ox = c_sprite:getWidth()
	elseif c_transform.ox == "left" then
		c_transform.ox = 0
	end
	if c_transform.oy == "center" then
		c_transform.oy = c_sprite:getHeight()/2
	elseif c_transform.oy == "bottom" then
		c_transform.oy = c_sprite:getHeight()
	end
end

function Transform:handleAnim(e)
	local c_anim = e[C.anim]
	local c_transform = e[C.transform]
	if c_anim.anim then
		if c_transform.ox == "center" then
			c_transform.ox = c_anim.anim:getWidth()/2
		elseif c_transform.ox == "right" then
			c_transform.ox = c_anim.anim:getWidth()
		elseif c_transform.ox == "left" then
			c_transform.ox = 0
		end
		if c_transform.oy == "center" then
			c_transform.oy = c_anim.anim:getHeight()/2
		elseif c_transform.oy == "bottom" then
			c_transform.oy = c_anim.anim:getHeight()
		end
	end
end

function Transform:changeScale(e, sx, sy, dur)
	local c_transform = e[C.transform]
	local c_maxScale = e[C.maxScale]
	flux.to(c_transform, dur or 0.25, {
			sx = sx or c_transform.orig_sx,
			sy = sy or c_transform.orig_sy,
		})
	if c_maxScale then
		if c_maxScale.max_sx then c_transform.sx = lume.clamp(c_transform.sx, 0, c_maxScale.max_sx) end
		if c_maxScale.max_sy then c_transform.sy = lume.clamp(c_transform.sy, 0, c_maxScale.max_sy) end
	end
end

return Transform
