# GO - all golang related commands -------------------------------------------------------------------------------------

LIST_ALL := $(shell go list ./... | grep -v /vendor/ | grep -v mocks)

all: lint test race

.PHONY: install
install: ## Install the dependencies (via dep)
	@dep ensure

.PHONY: update
update: ## Update the dependencies (via dep)
	@dep ensure -update

.PHONY: lint
lint: ## Lint all files (via golint)
	@go fmt ${LIST_ALL}
	@golint -set_exit_status ${LIST_ALL}

.PHONY: test
test: install ## Run unit tests
	@go test -short ${LIST_ALL}

.PHONY: race
race: install ## Run data race detector
	@go test -race -short ${LIST_ALL}

.PHONY: coverage
coverage: install ## Generate coverage report
	@go test ${LIST_ALL} -coverprofile coverage.out
	@go tool cover -func coverage.out
	@mkdir -p coverage
	@go tool cover -html=coverage.out -o coverage/index.html

.PHONY: report
report: coverage ## Open the coverage report in browser
	@go tool cover -html=coverage.out

.PHONY: clean
clean: ## Remove files around coverage report
	@rm -f coverage.out
	@rm -rf coverage/

# ----------------------------------------------------------------------------------------------------------------------

.PHONY: help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
