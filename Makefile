.PHONY: test help

NAME := devenv
PROJECT := uni
INSTALL_STAMP := .install.stamp
INSTALL_DEV_STAMP := .install_dev.stamp

export PATH := venv/bin:$(PATH)
export DOCKER_BUILDKIT := 1

# This nice little trick for generating a make help menu comes from
# https://www.thapaliya.com/en/writings/well-documented-makefiles/
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make <target>\033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build:  ## Build with Docker
	docker build -t ${PROJECT}/${NAME} .

run:  ## Build with Docker
	docker-compose up --build -d

run-%:  ## Start only one service (proxy|client)
	docker-compose up -d $*

stop:  ## Build with Docker
	docker-compose down

test: install-dev  ## Run unit tests with pytest
	pytest -v -s -rP ./tests

lint:  install-dev  # Run pre-commit on all makefiles
	pre-commit run -a
