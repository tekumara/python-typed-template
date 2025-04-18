MAKEFLAGS += --warn-undefined-variables --check-symlink-times
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help clean install format check pyright test dist hooks install-hooks

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

venv ?= .venv
# this is a symlink so we set the --check-symlink-times makeflag above
python := $(venv)/bin/python

$(python): $(if $(value CI),|,) .python-version
	uv venv

$(venv): $(if $(value CI),|,) pyproject.toml $(python)
	uv sync
	touch $(venv)

# delete the venv
clean:
	rm -rf $(venv)

## create venv and install this package and hooks
install: $(venv) $(if $(value CI),,install-hooks)

## format, lint and type check
check: export SKIP=test
check: hooks

## format and lint
format: export SKIP=pyright,test
format: hooks

## pyright type check
pyright: $(venv)
	PYRIGHT_PYTHON_IGNORE_WARNINGS=1 uv run pyright

## run tests
test: $(venv)
	uv run pytest

## build python distribution
dist: $(venv)
# start with a clean slate (see setuptools/#2347)
	rm -rf build dist *.egg-info
	uv run -m build --wheel

## publish to pypi
publish: $(venv)
	uv run twine upload dist/*

## run pre-commit git hooks on all files
hooks: $(venv)
	uv run pre-commit run --color=always --all-files --hook-stage push

install-hooks: .git/hooks/pre-push

.git/hooks/pre-push: $(venv)
	uv run pre-commit install --install-hooks -t pre-push
