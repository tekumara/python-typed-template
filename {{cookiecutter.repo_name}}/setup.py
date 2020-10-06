from pathlib import Path

from setuptools import find_packages, setup

long_description = Path("README.md").read_text()

setup(
    name="{{cookiecutter.distribution_name}}",
    version="0.0.0",
    description="{{cookiecutter.description}}",
    long_description=long_description,
    long_description_content_type="text/markdown",
    python_requires=">=3.7",
    packages=find_packages(exclude=["tests"]),
    include_package_data=True,
    install_requires=[],
    extras_require={
        "dev": [
            "black==20.8b1",
            # pin importlib_metadata to avoid conflict, must be <2
            "importlib_metadata==1.7.0",
            "isort==5.5.4",
            "flake8==3.8.4",
            "flake8-annotations==2.4.1",
            "flake8-colors==0.1.6",
            "pre-commit==2.7.1",
            "pytest==6.1.0",
        ]
    },
)
