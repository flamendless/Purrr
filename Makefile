run:
	lua build.lua
	love output

init:
	@if [ ! -d output/modules ]; then \
		cp -rf modules output/; \
	else \
		echo "modules already exists"; \
	fi
	@if [ ! -d output/assets ]; then \
		cp -rf assets output/; \
	else \
		echo "assets already exists"; \
	fi
	@if [ ! -d output/shaders ]; then \
		cp -rf shaders output/; \
	else \
		echo "shaders already exists"; \
	fi
	@if [ ! -d output/src ]; then \
		mkdir output/src; \
	else \
		echo "src already exists"; \
	fi
	@if [ ! -d output/states ]; then \
		mkdir output/states; \
	else \
		echo "states already exists"; \
	fi
	@if [ ! -d output/ecs ]; then \
		mkdir -p output/ecs/components; \
		mkdir -p output/ecs/systems; \
		mkdir -p output/ecs/entities; \
	else \
		echo "ecs already exists"; \
	fi

clean:
	@if [ -d output ]; then rm -rfi output; else echo "folder output does not exist"; fi
