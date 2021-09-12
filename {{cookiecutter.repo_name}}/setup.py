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
    package_data={
        "": ["py.typed"],
    },
    install_requires=[],
    extras_require={
        "dev": [
            "black==21.7b0",
            "isort==5.9.3",
            "flake8==3.9.2",
            "flake8-annotations==2.6.2",
            "flake8-colors==0.1.9",
            "pre-commit==2.15.0",
            "pytest==6.2.5",
        ]
    },
)
