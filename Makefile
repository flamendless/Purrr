run:
	lua build.lua
	love bin

init:
	@if [ ! -d bin/modules ]; then \
		cp -rf modules bin/; \
	else \
		echo "modules already exists"; \
	fi
	@if [ ! -d bin/assets ]; then \
		cp -rf assets bin/; \
	else \
		echo "assets already exists"; \
	fi
	@if [ ! -d bin/shaders ]; then \
		cp -rf shaders bin/; \
	else \
		echo "shaders already exists"; \
	fi
	@if [ ! -d bin/src ]; then \
		mkdir bin/src; \
	else \
		echo "src already exists"; \
	fi
	@if [ ! -d bin/states ]; then \
		mkdir bin/states; \
	else \
		echo "states already exists"; \
	fi
	@if [ ! -d bin/ecs ]; then \
		mkdir -p bin/ecs/components; \
		mkdir -p bin/ecs/systems; \
		mkdir -p bin/ecs/entities; \
	else \
		echo "ecs already exists"; \
	fi

clean:
	@if [ -f bin/main.lua ]; then rm bin/main.lua; else echo "main.lua does not exist"; fi
	@if [ -f bin/conf.lua ]; then rm bin/conf.lua; else echo "conf.lua does not exist"; fi
	@if [ -d bin/src ]; then rm -rf bin/src; else echo "src does not exist"; fi
	@if [ -d bin/states ]; then rm -rf bin/states; else echo "states does not exist"; fi
	@if [ -d bin/ecs ]; then rm -rf bin/ecs; else echo "ecs does not exist"; fi
