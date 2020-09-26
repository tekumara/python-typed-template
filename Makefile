MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help install check lint pyright test hooks install-hooks

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

test-dir := /tmp/pbt
test-cookie := $(test-dir)/cookie
venv := $(test-dir)/venv
cookiecutter := $(venv)/bin/cookiecutter

$(cookiecutter):
	python3 -m venv --clear $(venv)
	$(venv)/bin/pip install cookiecutter

## bake a test cookie and run make install hooks
test: $(cookiecutter)
	rm -rf $(test-cookie)
	$(cookiecutter) -o $(test-cookie) --no-input .
	ls -R1 $(test-cookie)
	cd $(test-cookie)/repo-name && git init && git add . && make install hooks
