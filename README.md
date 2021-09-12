# Python typed template 🐍

[![Build](https://github.com/tekumara/python-typed-template/actions/workflows/ci.yml/badge.svg)](https://github.com/tekumara/python-typed-template/actions/workflows/ci.yml)

A minimal, generic, and opinionated template for **typed ✨** python projects that includes:

- enforced type hints for non-test code because [_"explicit is better than implicit"_](https://www.python.org/dev/peps/pep-0020/)
- [pyright](https://github.com/tekumara/notes/blob/master/pyright.md) to check those type hints because it's more accurate and faster than mypy
- flake8 which is faster than pylint and [comprehensive enough](https://github.com/tekumara/notes/blob/master/python-linting.md)
- a line length of 120 and black as formatter
- pytest for tests because it doesn't [require classes](https://www.youtube.com/watch?v=o9pEzgHorH0) unlike unittest
- [pre-commit](https://github.com/tekumara/notes/blob/master/pre-commit.md) to run the above on push, rather than commit, so your flow is interrupted less. Handy when you don't have CI or working in environments (eg: EC2, JupyterHub) without an IDE.
- [setup.py]({{cookiecutter.repo_name}}/setup.py) for describing requirements including >= python 3.7 (ie: no requirements.txt)
- a [Makefile]({{cookiecutter.repo_name}}/Makefile) for development/CI. It creates a virtualenv in _.venv/_ and sets up your development environment ie: git hooks, formatters and linters. When the requirements in `setup.py` change, the virtualenv is updated. No pipenv/poetry/conda required.
- a single virtualenv is assumed with a set of requirements for all packages, rather than a monorepo with multiple projects that have different requirements
- a directory structure that prescribes packages at the top-level for convenience rather than under _src/_
- repo and package naming conventions (see [Template parameters](#template-parameters) below)

And not much else. This is meant to be generic, so anything specific to only a subset of projects probably lives elsewhere.

## Project development prerequisites

Projects created using this template have [development prerequisites]({{cookiecutter.repo_name}}/README.md#Prerequisites). This includes node, which is required for pyright.

## Template parameters

The template will ask for the following:

- `repo_name`: The name of your repo. Repo names are lowered kebab-case, so hyphens rather than underscores, to be kind to humans.
- `package_name`: The name of your main python package. A python package is a group of modules, ie: a directory with _\_\_init\_\_.py_ file. Choose a short all-lowercase name without hyphens. The use of underscores is discouraged (see [PEP8](https://www.python.org/dev/peps/pep-0008/#package-and-module-names)).
- [`distribution_name`](https://www.python.org/dev/peps/pep-0508/#names): The name of the artifact when your project is built as a wheel or source distribution (aka sdist). Distributions names are lowered kebab-case. In most cases the package name and distribution name will be the same. This is used in _setup.py_ and needed even if you aren't building a wheel or sdist.
- `description`: a one line description of your project.

## Getting started

Install cookiecutter using [pipx](https://github.com/pipxproject/pipx):

```
pipx install cookiecutter
```

To create a project, aka bake a cookie 🍪:

```
cookiecutter git@github.com:tekumara/python-typed-template.git
# replace repo-name below with the name you specified during template creation
cd repo-name
git init && git commit -m 'root commit' --allow-empty
make install
```

## Contributing 🌱

If you think there's something here that would benefit everyone, or what's here no longer follows common practice, please submit any changes via a PR!

## Dependencies

To identify outdated dependencies used by the template run `make outdated`

## Testing

After making a change run `make test` to bake a project into _/tmp/cookie_
