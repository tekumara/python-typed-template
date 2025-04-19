# Contributing 🌳

## Prerequisites

- make
- python >= 3.11
- uv >= 0.5.0

## Getting started

`make install` creates the dev environment with:

- a virtualenv in _.venv/_
- git hooks for formatting & linting on git push

`. .venv/bin/activate` activates the virtualenv.

The make targets will update the virtualenv when _pyproject.toml_ changes.

## Usage

Run `make` to see the options for running tests, linting, formatting etc.
