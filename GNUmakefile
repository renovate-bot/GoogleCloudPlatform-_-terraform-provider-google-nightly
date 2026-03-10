TEST?=$$(go list -e ./... | grep -v github.com/hashicorp/terraform-provider-google-beta/scripts)
DIR_NAME=google-nightly

GO111MODULE=on

default: build

build: lint
	go install

test: lint testnolint

# Used in CI to prevent lint failures from being interpreted as test failures
testnolint:
	go test $(TESTARGS) -timeout=30s $(TEST)

testacc: lint
	TF_ACC=1 TF_SCHEMA_PANIC_ON_ERROR=1 go test $(TEST) -v $(TESTARGS) -timeout 240m -ldflags="-X=github.com/hashicorp/terraform-provider-google-nightly/google-nightly/version.ProviderVersion=acc"

vet:
	go vet

lint: fmtcheck vet

# Currently required by tf-deploy compile
fmtcheck:
	@sh -c "'$(CURDIR)/scripts/gofmtcheck.sh'"

fmt:
	@echo "==> Fixing source code with gofmt..."
	gofmt -w -s ./$(DIR_NAME)