# set default shell
SHELL := $(shell which bash)
OSARCH := "linux/amd64 linux/386 windows/amd64 windows/386 darwin/amd64 darwin/386"
ENV = /usr/bin/env
GO111MODULE=on

.SHELLFLAGS = -c

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell

.PHONY: all
.DEFAULT: build

help: ## Show Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


dep: ## Get build dependencies
	go get -v github.com/mitchellh/gox

build: ## Build blackbeard
	$(ENV) go build -o postmanify cmd/postmanify/main.go

cross-build: ## Build blackbeard for multiple os/arch
	$(ENV) gox -osarch=$(OSARCH) -output "bin/postmanify_{{.OS}}_{{.Arch}}"

test: ## Launch tests
	$(ENV) go test -v ./...

test-cover: ## Launch test coverage and send it to coverall
	$(ENV) ./scripts/test-coverage.sh
