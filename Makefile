ifeq ($(OS),Windows_NT)
	COPY_CMD = copy
else
	COPY_CMD = cp
endif

SED_COMMAND = sed 's/=.*//'
ENV_COMMAND = $(SED_COMMAND) .env

ifneq (,$(wildcard .env))
    include .env
    export $(shell $(ENV_COMMAND))
endif

WEB_ENV_FILE ?= .env.production
WEB_DOCKER_IMAGE ?= fe-middleware-payment:latest
VERSION ?= 1.0.0
BUILDNUMBER ?= 1

copyEnvDev:
	$(COPY_CMD) .env.development .env

copyEnvProd:
	$(COPY_CMD) .env.production .env

releaseWeb:
	docker build --platform linux/amd64 -f Dockerfile \
		--build-arg BUILD_ENV_FILE=$(WEB_ENV_FILE) \
		--build-arg APP_VERSION=$(VERSION) \
		--build-arg APP_BUILDNUMBER=$(BUILDNUMBER) \
		-t $(WEB_DOCKER_IMAGE) .
	mkdir -p ./deploy
	CONTAINER_ID=$$(docker create $(WEB_DOCKER_IMAGE)); \
	docker cp $$CONTAINER_ID:/output/deploy/. ./deploy; \
	docker rm $$CONTAINER_ID

deployWeb:
	make copyEnvProd
	make releaseWeb
