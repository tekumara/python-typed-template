# Design choices

- a [Makefile]({{cookiecutter.repo_name}}/Makefile) to use as a task runner during development/CI.
- the makefile uses [uv](https://github.com/astral-sh/uv) to create a virtualenv and install dependencies. uv is faster than pip at dependency resolution and installation.
- [ruff](https://github.com/charliermarsh/ruff) for linting, formatting similar to [black](https://docs.astral.sh/ruff/faq/#how-does-ruffs-formatter-compare-to-black), import sorting, and auto fixing (eg: removing unused imports) because its the fastest and most feature complete linter
- enforced type hints for non-test code because [_"explicit is better than implicit"_](https://www.python.org/dev/peps/pep-0020/)
- [pyright](https://github.com/tekumara/notes/blob/main/pyright.md) to check those type hints because it's more accurate and faster than mypy
- pytest for tests because it doesn't [require classes](https://www.youtube.com/watch?v=o9pEzgHorH0) unlike unittest
- [setuptools](https://setuptools.pypa.io/en/latest/userguide/index.html) for building wheels because its the [most popular build backend](https://venthur.de/2024-01-26-build-backends.html) and does the job. Source dists (sdists) aren't built because they aren't useful.
- [pyproject.toml]({{cookiecutter.repo_name}}/pyproject.toml) for describing requirements and python versions as per PEP 621 (ie: no requirements.txt)

## Pre-commit

pre-commit is used for linting, formatting, type checking and testing using the tools above. pre-commit is particularly useful in remote environments without an IDE, or for projects without CI.

Tools are configured as a `git push` hook instead of `git commit` to minimise interruptions. They can also be run on-demand via the Makefile. The Makefile uses pre-commit, instead of directly running the tools, because pre-commit will nicely collapse output on success and continue running subsequent tools when a previous one fails.

The version of pre-commit is major-version constrained to avoid breaking changes (see this [example](https://github.com/tekumara/fakesnow/pull/147/files)). The version is specified as a `dev` dependency, rather than in the makefile, so that dependabot can bump it. This has the slight disadvantage of polluting the dependency tree, which must now satisfy pre-commit's dependencies.

## Project structure

A single virtualenv is assumed with requirements for all packages, rather than a monorepo with multiple projects that have different requirements.
The directory structure prescribes packages at the top-level for convenience rather than under _src/_.

## Cruft

[Cruft](https://github.com/cruft/cruft) uses cookiecutter under the hood to bake a cookie. But unlike cookiecutter, cruft creates a _.cruft.json_ file which records the commit hash of the template used and the prompt values provided by the user at the time of baking. Projects baked using cruft can be aligned with future versions of the template by running `cruft update`. This does a 3-way merge to apply template changes made since baking.
