MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help clean test outdated

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

test-cookie := /tmp/cookie-ptt/my-repo
venv := .venv
cookiecutter := $(venv)/bin/cookiecutter

$(cookiecutter):
	python3 -m venv --clear $(venv)
	$(venv)/bin/pip install cookiecutter

## remove the test cookie
clean:
	rm -rf $(test-cookie)

## bake a test cookie and run make hooks
test: clean $(test-cookie)

$(test-cookie): $(cookiecutter)
	$(cookiecutter) -o $(test-cookie)/../ --no-input --config-file cookiecutter-config.yaml .
ifndef SKIP_HOOKS
	cd $(test-cookie) && git init && git add . && make hooks
endif

## list outdated packages
outdated: $(test-cookie)
	$(test-cookie)/.venv/bin/pip list --outdated
	cd $(test-cookie) && npm outdated

pc-update: $(test-cookie)
	cd $(test-cookie) && .venv/bin/pre-commit autoupdate
	cp $(test-cookie)/.pre-commit-config.yaml {{cookiecutter.repo_name}}/
