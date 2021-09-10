.PHONY: build

ONOS_BUILD_VERSION := latest

all:
	cat README.md

license_check: # @HELP examine and ensure license headers exist
	./licensing/boilerplate.py -v --rootdir=${CURDIR}/build

linters: golang-ci # @HELP examines Go source code and reports coding problems
	golangci-lint run --timeout 5m

jenkins-tools: # @HELP installs tooling needed for Jenkins
	cd .. && go get -u github.com/jstemmer/go-junit-report && go get github.com/t-yuki/gocover-cobertura

golang-ci: # @HELP install golang-ci if not present
	golangci-lint --version || curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b `go env GOPATH`/bin v1.42.0

golang-build-docker: # @HELP build golang-build Docker image
	docker build -t onosproject/golang-build:${ONOS_BUILD_VERSION} build/golang-build

protoc-go-docker: # @HELP build protoc-go Docker image
	docker build -t onosproject/protoc-go:${ONOS_BUILD_VERSION} build/protoc-go

publish: # @HELP publish version on github and dockerhub
	./publish-version ${VERSION} onosproject/protoc-go onosproject/golang-build

images: # @HELP create docker images
images: protoc-go-docker golang-build-docker

clean: # @HELP remove all the build artifacts
	rm -rf ./web/onos-gui/dist

jenkins-test: # @HELP jenkins verify target
jenkins-test: jenkins-tools test
	TEST_PACKAGES="NONE" ./../build-tools/build/jenkins/make-unit

test: # @HELP testing target
test: images license_check linters

jenkins-publish: # @HELP jenkins publishing target
jenkins-publish: jenkins-tools # @HELP Jenkins calls this to publish artifacts
	./build/bin/push-images
	./release-merge-commit

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
