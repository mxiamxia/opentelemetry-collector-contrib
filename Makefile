include ./Makefile.Common

RUN_CONFIG=local/config.yaml

CMD?=
GIT_SHA=$(shell git rev-parse --short HEAD)
BUILD_INFO_IMPORT_PATH=github.com/open-telemetry/opentelemetry-collector-contrib/internal/version
BUILD_X1=-X $(BUILD_INFO_IMPORT_PATH).GitHash=$(GIT_SHA)
ifdef VERSION
BUILD_X2=-X $(BUILD_INFO_IMPORT_PATH).Version=$(VERSION)
endif
BUILD_X3=-X github.com/open-telemetry/opentelemetry-collector/internal/version.BuildType=$(BUILD_TYPE)
BUILD_INFO=-ldflags "${BUILD_X1} ${BUILD_X2} ${BUILD_X3}"
STATIC_CHECK=staticcheck

.DEFAULT_GOAL := all

.PHONY: all
all: common otelcontribcol

.PHONY: e2e-test
e2e-test: otelcontribcol
	$(MAKE) -C testbed runtests

.PHONY: precommit
precommit:
	$(MAKE) gotidy
	$(MAKE) ci

.PHONY: test-with-cover
test-with-cover:
	@echo Verifying that all packages have test files to count in coverage
	@scripts/check-test-files.sh $(subst github.com/open-telemetry/opentelemetry-collector-contrib/,./,$(ALL_PKGS))
	@echo pre-compiling tests
	set -e; for dir in $(ALL_MODULES); do \
	  echo "go test ./... + coverage in $${dir}"; \
	  (cd "$${dir}" && \
	    $(GOTEST) $(GOTEST_OPT_WITH_COVERAGE) ./... && \
	 	go tool cover -html=coverage.txt -o coverage.html ); \
	done

.PHONY: gotidy
gotidy:
	$(MAKE) for-all CMD="go mod tidy"

.PHONY: gofmt
gofmt:
	$(MAKE) for-all CMD="make fmt"

.PHONY: for-all
for-all:
	@$${CMD}
	@set -e; for dir in $(ALL_MODULES); do \
	  (cd "$${dir}" && \
	  	echo "running $${CMD} in $${dir}" && \
	 	$${CMD} ); \
	done

.PHONY: install-tools
install-tools:
	go install github.com/client9/misspell/cmd/misspell
	go install github.com/golangci/golangci-lint/cmd/golangci-lint
	go install github.com/google/addlicense
	go install honnef.co/go/tools/cmd/staticcheck
	go install github.com/pavius/impi/cmd/impi
	go install github.com/tcnksm/ghr

.PHONY: run
run:
	GO111MODULE=on go run --race ./cmd/otelcontribcol/... --config ${RUN_CONFIG}

.PHONY: docker-component # Not intended to be used directly
docker-component: check-component
	GOOS=linux GOARCH=amd64 $(MAKE) $(COMPONENT)
	cp ./bin/$(COMPONENT)_linux_amd64 ./cmd/$(COMPONENT)/$(COMPONENT)
	docker build -t $(COMPONENT) ./cmd/$(COMPONENT)/
	rm ./cmd/$(COMPONENT)/$(COMPONENT)

.PHONY: check-component
check-component:
ifndef COMPONENT
	$(error COMPONENT variable was not defined)
endif

.PHONY: docker-otelcontribcol
docker-otelcontribcol:
	COMPONENT=otelcontribcol $(MAKE) docker-component

.PHONY: otelcontribcol
otelcontribcol:
	GO111MODULE=on CGO_ENABLED=0 go build -o ./bin/otelcontribcol_$(GOOS)_$(GOARCH) $(BUILD_INFO) ./cmd/otelcontribcol


.PHONY: otelcontribcol-all-sys
otelcontribcol-all-sys: otelcontribcol-darwin_amd64 otelcontribcol-linux_amd64 otelcontribcol-linux_arm64 otelcontribcol-windows_amd64

.PHONY: otelcontribcol-darwin_amd64
otelcontribcol-darwin_amd64:
	GOOS=darwin  GOARCH=amd64 $(MAKE) otelcontribcol

.PHONY: otelcontribcol-linux_amd64
otelcontribcol-linux_amd64:
	GOOS=linux   GOARCH=amd64 $(MAKE) otelcontribcol

.PHONY: otelcontribcol-linux_arm64
otelcontribcol-linux_arm64:
	GOOS=linux   GOARCH=arm64 $(MAKE) otelcontribcol

.PHONY: otelcontribcol-windows_amd64
otelcontribcol-windows_amd64:
	GOOS=windows GOARCH=amd64 $(MAKE) otelcontribcol

.PHONY: update-dep
update-dep:
	$(MAKE) for-all CMD="$(PWD)/scripts/update-dep"
	$(MAKE) otelcontribcol
	$(MAKE) gotidy

.PHONY: update-otel
update-otel:
	$(MAKE) update-dep MODULE=go.opentelemetry.io/collector VERSION=master
