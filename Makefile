.ONESHELL:
ENV_PREFIX=$(shell if conda env list | grep -q htmlenv; then echo "conda run -n htmlenv "; fi)

SHELL := /bin/bash
USE_CONDA ?= true  # Default to true if not explicitly set
MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
HTML_PATH := $(MAKEFILE_DIR)  

.PHONY: help
help:             ## Show the help menu.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# === Code Quality ===

.PHONY: fmt
fmt:              ## Format HTML, CSS, and JS files using Prettier.
	$(ENV_PREFIX)npx prettier --write .

.PHONY: lint
lint:             ## Lint HTML files using htmlhint.
	$(ENV_PREFIX)npx htmlhint .

# === Testing ===

.PHONY: test
test: lint        ## Run tests (if applicable).
	@echo "No tests defined. Add testing commands here if needed."

# === Cleanup ===

.PHONY: clean
clean: ## Remove temporary and unnecessary files.
	@echo "Running clean in $(HTML_PATH)"
	@find "$(HTML_PATH)" -name '*.bak' -exec rm -f {} + || true
	@find "$(HTML_PATH)" -name '*~' -exec rm -f {} + || true
	@rm -rf .cache node_modules dist || true
	@echo "Clean completed"
