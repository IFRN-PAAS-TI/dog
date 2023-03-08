#check if docker compose or docker-compose
DOCKER_COMPOSE:=$(shell which docker-compose || echo 'docker compose')

define INFO
Available commands:

info: this help
build: docker-compose build
debug: docker-compose run -it fog /bin/bash
start: docker-compose up
endef
export INFO

.PHONY: all
all: build

.PHONY: build
build:
	$(DOCKER_COMPOSE) build --progress=plain

.PHONY:info
info:
	@echo "$$INFO"

.PHONY: debug
debug:
	$(DOCKER_COMPOSE) run -it fog /bin/bash

.PHONY: start
start:
	$(DOCKER_COMPOSE) up
