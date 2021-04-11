MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help clean test outdated

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

test-cookie := /tmp/cookie
venv := .venv
cookiecutter := $(venv)/bin/cookiecutter

$(cookiecutter):
	python3 -m venv --clear $(venv)
	$(venv)/bin/pip install cookiecutter

clean:
	rm -rf $(test-cookie)

$(test-cookie): $(cookiecutter)
	$(cookiecutter) -o $(test-cookie) --no-input .
	ls -R1 $(test-cookie)
	cd $(test-cookie)/repo-name && git init && git add . && make install hooks

## bake a test cookie and run make install hooks
test: clean $(test-cookie)

## list outdated packages
outdated: $(test-cookie)
	$(test-cookie)/repo-name/.venv/bin/pip list --outdated
	cd $(test-cookie)/repo-name && npm outdated
