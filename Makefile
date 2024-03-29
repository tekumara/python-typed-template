MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help snapshot test outdated pc-update

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

snapshot := snapshot/cookie
venv := .venv
cookiecutter := $(venv)/bin/cookiecutter

$(cookiecutter):
	python3 -m venv --clear $(venv)
	$(venv)/bin/pip install cookiecutter

## make the snapshot cookie
snapshot: $(snapshot)

## run hooks on snapshot cookie
test: $(snapshot)
	cd $(snapshot) && git init && git add . && make hooks

$(snapshot): $(shell find {{cookiecutter.repo_name}}) cookiecutter* | $(cookiecutter)
	rm -rf $(snapshot)
	$(cookiecutter) -o $(snapshot)/../ -f --no-input --config-file cookiecutter-config.yaml .
	touch $(snapshot)

$(snapshot)/.venv: $(snapshot)
	cd $(snapshot) && make install

## list outdated packages
outdated: $(snapshot)/.venv
	$(snapshot)/.venv/bin/pip list --outdated
	cd $(snapshot) && npm outdated

## update pre-commit hooks
pc-update: $(snapshot)/.venv
	cd $(snapshot) && .venv/bin/pre-commit autoupdate
	cp -p $(snapshot)/.pre-commit-config.yaml {{cookiecutter.repo_name}}/
