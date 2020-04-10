.PHONY: build

ONOS_BUILD_VERSION := latest

license_check: # @HELP examine and ensure license headers exist
	./../licensing/boilerplate.py -v --rootdir=${CURDIR}

golang-build-docker: # @HELP build golang-build Docker image
	docker build -t onosproject/golang-build:${ONOS_BUILD_VERSION} build/golang-build

protoc-go-docker: # @HELP build protoc-go Docker image
	docker build -t onosproject/protoc-go:${ONOS_BUILD_VERSION} build/protoc-go

all:
	cat README.md

publish: # @HELP publish version on github and dockerhub
	./publish-version ${VERSION} onosproject/protoc-go

clean: # @HELP remove all the build artifacts
	rm -rf ./web/onos-gui/dist

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
