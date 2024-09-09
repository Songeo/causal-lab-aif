![AIF](docs/img/bbva.png)
# Causal Lab AIF

---

## Causal Lab AIF Team

- Miguel Daygoro Grados Fukuda
- Sonia Georgina Mendizabal Claustro
- Arturo Soberon Cedillo
- Ashutosh Dadhich
- Juan Pablo Rodrigo Lagunes Gomez
- Gaspar García Baez
- David Chaffrey Moreno Fernández
- Alejandro Aguayo-Ortiz

---

## Contents

To see the Causal Analysis Lab topics, go to the [contents](CONTENTS.md)

---

## Init Poetry environment

Activate Poetry virtual environment by running:
```bash
$ poetry shell
```
or by running:
```bash
$ make
```
in order to install all dependencies and setup environment.

---

## Installing dependencies

Install primary dependencies using:
```bash
$ poetry add <package>
```

Install development dependencies using:
```bash
$ poetry add <package> --group dev
```

---

## Contributing

In order to contribute with some new research, feature, fixture or documentation:

1. Move to a new branch. Use the naming convention stablished in the [NAMING CONVENTION](NAMING.md) file.

2. Add your notebooks, modules or, in general, contribution.

3. Perform a linting to ensure good practices over all added files by running:
```bash
$ make pre-commit
```

4. Commit your changes by running:
```bash
$ make commit
```

If you want to avoid the pre-commit hooks, commit your changes by running:
```bash
$ git add .
$ git commit --no-verify
```

---

## Documentation

To deploy documentation in a localhost, run:
```bash
$ make doc-serve
```

---

## Project requirements

- [ ] Tests
    - [ ] [Code coverage (0%)](coverage/index.html)
    - [ ] Unit tests
    - [ ] Feature tests
    - [ ] Integration tests
    - [ ] Performance tests
- [ ] Quality Assurance
    - [ ] Code covereage
    - [ ] Code quality
    - [ ] Code style
- [ ] Profiling
    - [ ] Execution time
    - [ ] Memory usage
    - [ ] CPU usage
- [ ] CI/CD
    - [ ] Github actions
- [ ] Demo app
- [ ] Notebooks

---
