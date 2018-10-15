uniform sampler2D palette;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
   vec4 source = Texel(texture, texture_coords);
   vec4 pixel = Texel(palette, vec2(source.r, 0));
   pixel.a = source.a;
   return pixel * color;
}

//USAGE
/*
local shader = love.graphics.newShader("shader.glsl")

local sprite = love.graphics.newImage("sprite.png")
sprite:setFilter("nearest", "nearest")

local palettes = {
   love.graphics.newImage("palette1.png"),
   love.graphics.newImage("palette2.png"),
}
local active = 1

function love.draw()
   shader:send("palette", palettes[active])
   love.graphics.setShader(shader)
      love.graphics.draw(sprite, 0, 0, 0, 8, 8)
   love.graphics.setShader()
end

function love.keypressed()
   active = active + 1
   if active > #palettes then
      active = 1
   end
end
*/
