SHELL := /bin/zsh
ANDROID = PATH:/opt/android-sdk/build-tools/28.0.2
PROJECT_NAME = purrr
LOVE_NAME = game.love
ROOT_DIR = .
OUTPUT_DIR = output
DIRECTORIES = modules assets shaders src states ecs

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
			cp -rf $$x ${OUTPUT_DIR}/; \
		else \
			@echo "$$x already exists"; \
		fi; \
	done

clean:
	@if [ -d ${OUTPUT_DIR} ]; then rm -rf ${OUTPUT_DIR}; else echo "${OUTPUT_DIR} does not exist"; fi
