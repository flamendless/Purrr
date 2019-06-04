SHELL := /bin/zsh
ANDROID = PATH:/opt/android-sdk/build-tools/28.0.2
PROJECT_NAME = purrr
LOVE_NAME = game.love
ROOT_DIR = .
OUTPUT_DIR = output
DIRECTORIES = modules assets shaders src states base ecs/components ecs/systems ecs/entities
DIRECTORIES_TO_COPY = modules assets shaders src states base

run:
	lua build.lua
	love ${OUTPUT_DIR}

init:
	@if [ ! -d ${OUTPUT_DIR} ]; then \
		mkdir ${OUTPUT_DIR}; \
	else \
		@echo "${OUTPUT_DIR} already exists"; \
	fi
	@for x (${DIRECTORIES}); do \
		if [ ! -d ${OUTPUT_DIR}/$$x ]; then \
			mkdir -p ${OUTPUT_DIR}/$$x; \
		else \
			echo "$$x already exists"; \
		fi; \
	done
	@for x (${DIRECTORIES_TO_COPY}); do \
		rsync -avP --exclude="*.lua2p" $$x ${OUTPUT_DIR}/; \
	done

clean:
	@if [ -d ${OUTPUT_DIR} ]; then rm -rf ${OUTPUT_DIR}; else echo "${OUTPUT_DIR} does not exist"; fi
