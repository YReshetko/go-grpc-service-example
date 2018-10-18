PROJECT_ROOT		:= my-app-example
BUILD_PATH		:= bin
DOCKERFILE_PATH		:= $(CURDIR)/docker

# configuration for image names
USERNAME		:= $(USER)
GIT_COMMIT		:= $(shell git describe --dirty=-unsupported --always || echo pre-commit)
#IMAGE_VERSION		?= $(USERNAME)-dev-$(GIT_COMMIT)
IMAGE_VERSION		?= ltst

# configuration for server binary and image
SERVER_BINARY 		:= $(BUILD_PATH)/server
SERVER_PATH		:= $(PROJECT_ROOT)/cmd/server
SERVER_IMAGE		:= my-app-example-server
DB_IMAGE		:= my-app-example-db
SERVER_DOCKERFILE	:= $(DOCKERFILE_PATH)/Dockerfile

# configuration for the protobuf gentool
SRCROOT_ON_HOST		:= $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
SRCROOT_IN_CONTAINER	:= /go/src/$(PROJECT_ROOT)
DOCKER_RUNNER    	:= docker run -u `id -u`:`id -g` --rm
DOCKER_RUNNER		+= -v $(SRCROOT_ON_HOST):$(SRCROOT_IN_CONTAINER)
DOCKER_GENERATOR	:= infoblox/atlas-gentool:latest
GENERATOR		:= $(DOCKER_RUNNER) $(DOCKER_GENERATOR)

# configuration for the database
DATABASE_ADDRESS	?= localhost:5432
DATABASE_USERNAME	?= postgres
DATABASE_PASSWORD	?= postgres
DATABASE_NAME       = my_app_example
DATABASE_URL        ?= postgres://$(DATABASE_USERNAME):$(DATABASE_PASSWORD)@$(DATABASE_ADDRESS)/$(DATABASE_NAME)?sslmode=disable
DB_SRC              := $(CURDIR)/db
IMAGE_DEV_DB        ?= test-db:test
DB_DOCKER_FILE      := $(DB_SRC)/Dockerfile

MIGRATETOOL_IMAGE           = infoblox/migrate:latest
MIGRATION_PATH_IN_CONTAINER = $(SRCROOT_IN_CONTAINER)/db/migrations

# configuration for building on host machine
GO_CACHE		:= -pkgdir $(BUILD_PATH)/go-cache
GO_BUILD_FLAGS		?= $(GO_CACHE) -i -v
GO_TEST_FLAGS		?= -v -cover
GO_PACKAGES		:= $(shell go list ./... | grep -v vendor)

.PHONY: all
all: vendor protobuf docker

.PHONY: fmt
fmt:
	@go fmt $(GO_PACKAGES)

.PHONY: test
test: fmt
	@go test $(GO_TEST_FLAGS) $(GO_PACKAGES)

.PHONY: docker
docker:
	@docker build -f $(DB_DOCKER_FILE) -t $(DB_IMAGE):$(IMAGE_VERSION) .
	@docker build -f $(SERVER_DOCKERFILE) -t $(SERVER_IMAGE):$(IMAGE_VERSION) .
	@docker image prune -f --filter label=stage=server-intermediate
.PHONY: protobuf
protobuf:
	@$(GENERATOR) \
	-I=$(PROJECT_ROOT)/vendor \
	--go_out=plugins=grpc:. \
	--grpc-gateway_out=logtostderr=true:. \
	--gorm_out=. \
	--validate_out="lang=go:." \
	--swagger_out=:. $(PROJECT_ROOT)/pkg/pb/service.proto

.PHONY: vendor
vendor:
	@dep ensure -vendor-only

.PHONY: vendor-update
vendor-update:
	@dep ensure

.PHONY: clean
clean:
	@docker rm $(shell docker ps -a -q) || true
	@docker rmi -f $(shell docker images -q $(DB_IMAGE)) || true
	@docker rmi -f $(shell docker images -q $(SERVER_IMAGE)) || true

.PHONY: up
up: docker
		@docker-compose up -d db
		@docker-compose up -d server
.PHONY: down
down:
	@docker-compose down
.PHONY: migrate-up
migrate-up:
	@$(DOCKER_RUNNER) --net="host" ${MIGRATETOOL_IMAGE} --verbose --path=$(MIGRATION_PATH_IN_CONTAINER)/ --database.dsn=$(DATABASE_URL) up

.PHONY: migrate-down
migrate-down:
	@$(DOCKER_RUNNER) --net="host" ${MIGRATETOOL_IMAGE} --verbose --path=$(MIGRATION_PATH_IN_CONTAINER)/ --database.dsn=$(DATABASE_URL) down
