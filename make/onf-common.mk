DOCKER_REPOSITORY ?= onosproject/
KIND_CLUSTER_NAME ?= kind

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '

deps: # @HELP ensure that the required dependencies are in place
	go build -v ./...
	bash -c "diff -u <(echo -n) <(git diff go.mod)"
	bash -c "diff -u <(echo -n) <(git diff go.sum)"

linters: golang-ci # @HELP examines Go source code and reports coding problems
	golangci-lint run --timeout 15m

gofmt: # @HELP run the Go format validation
	bash -c "diff -u <(echo -n) <(gofmt -d pkg/ cmd/ tests/)"

jenkins-tools: # @HELP installs tooling needed for Jenkins
	cd .. && go get -u github.com/jstemmer/go-junit-report && go get github.com/t-yuki/gocover-cobertura

golang-ci: # @HELP install golang-ci if not present
	golangci-lint --version || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b `go env GOPATH`/bin v1.42.1

license_check: # @HELP examine and ensure license headers exist
	./build/build-tools/licensing/boilerplate.py -v --skipped-dir build --rootdir=${CURDIR}

license_check_member_only: # @HELP examine and ensure license headers exist for member only license
	./build/build-tools/licensing/boilerplate.py -v --skipped-dir build --rootdir=${CURDIR} --boilerplate LicenseRef-ONF-Member-Only-1.0

bumponosdeps: # @HELP update "onosproject" go dependencies and push patch to git.
	./build/build-tools/bump-onos-deps ${VERSION}

integration-test-namespace:
	(kubectl delete ns test || exit 0) && kubectl create ns test

clean:: # @HELP cleans the downloaded build tools directory
	rm -rf ./build/build-tools
