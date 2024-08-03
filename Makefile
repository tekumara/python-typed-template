MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help test outdated pc-update

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

venv := .venv
cookiecutter := $(venv)/bin/cookiecutter

$(venv):
	python3 -m venv --clear $(venv)
	$(venv)/bin/pip install cookiecutter pre-commit

## create venv and install cookiecutter and hooks
install: $(venv) $(if $(value CI),,install-hooks)


## run hooks on default snapshot
test: snapshots
	cd snapshots/default && git init && git add . && make hooks

## make the snapshots
snapshots: $(shell find {{cookiecutter.repo_name}}) snapshots/*.yaml | $(venv)
	rm -rf snapshots/*/
	for file in snapshots/*.yaml; do $(cookiecutter) -o snapshots -f --no-input --config-file $$file .; done
	touch snapshots

snapshots/default/.venv: snapshots
	cd snapshots/default && make install

## list outdated packages
outdated: snapshots/default/.venv
	snapshots/default/.venv/bin/pip list --outdated
	cd snapshots/default && npm outdated

## update pre-commit hooks
pc-update: snapshots/default/.venv
	cd snapshots/default && .venv/bin/pre-commit autoupdate
	cp -p snapshots/default/.pre-commit-config.yaml {{cookiecutter.repo_name}}/

install-hooks: .git/hooks/pre-push

.git/hooks/pre-push: $(venv)
	$(venv)/bin/pre-commit install --install-hooks -t pre-push
