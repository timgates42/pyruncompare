
USER := $(shell id -u):$(shell id -g)
ARGS ?= --python 3.7

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help

.PHONY: build
build: ## Build the Docker Images
	docker-compose build
	docker-compose up -d
	docker-compose down

.PHONY: pipenv
pipenv: ## Prepare pipenv environment 
	docker-compose build
	docker-compose up -d
	docker-compose run -u "$(USER)" app make ARGS="$(ARGS)" _pipenv
	docker-compose down
