MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help install test outdated pc-update hooks

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

## create venv and install cookiecutter and hooks
install: $(if $(value CI),,install-hooks)

## run hooks on default snapshot
test: snapshots
	cd snapshots/default && git init && git add . && make hooks

## make the snapshots
snapshots: $(shell find {{cookiecutter.repo_name}}) snapshots/*.yaml
	rm -rf snapshots/*/
	for file in snapshots/*.yaml; do uvx cookiecutter -o snapshots -f --no-input --config-file $$file .; done
	touch snapshots

snapshots/default/.venv: snapshots
	cd snapshots/default && make install

## list outdated packages
outdated: snapshots/default/.venv
	cd snapshots/default && uv tree --outdated
	cd snapshots/default && npm outdated

## update pre-commit hooks
pc-update: snapshots/default/.venv
	uvx prek autoupdate
	cd snapshots/default && uvx prek autoupdate
	cp -p snapshots/default/.pre-commit-config.yaml {{cookiecutter.repo_name}}/

install-hooks: .git/hooks/pre-push

.git/hooks/pre-push:
	uvx prek install --install-hooks -t pre-push

## run pre-commit git hooks on all files
hooks:
	uvx prek run --color=always --all-files --hook-stage pre-push
