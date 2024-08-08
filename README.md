# Enterprise Agents Co-Pilot

Local repository for **Enterprise Agents Co-Pilot** project.

---

## Install requirements

- `brew install libmagic`
- `brew install tesseract-ocr`
- `brew install libtesseract-dev`
- `brew install libgl1`

---

## Project requirements

- [x] Tests
    - [x] [Code coverage (82%)](coverage/index.html)
    - [x] Unit tests
    - [x] Feature tests
    - [ ] Integration tests
    - [ ] Performance tests
- [x] Quality Assurance
    - [x] Code covereage
    - [x] Code quality
    - [x] Code style
- [ ] Profiling
    - [ ] Execution time
    - [ ] Memory usage
    - [ ] CPU usage
- [ ] CI/CD
    - [ ] Bitbucket actions
    - [ ] Jenkins
- [x] Demo app
- [x] Notebooks

---

## Documentation

Run:
```bash
$ make doc-serve
```

---

## Namiming convention according to the Python Enhancement Proporsal (PEP).

- Names to avoid:

    - Never use `l`, `O` or `I` as single character variable names.
    - Avoid one letter names, if possible.
    - Avoid not obvious abreviations.

- Files and Directories (PEP8):

    - Module directory or file:
        - Short, all-lowercase names.
        - Underscores can be used if it improves readability.
        - Examples:
            - `tests/`
            - `utils/`
            - `model_training.py`

    - Package directory:
        - Short, all-lowercase names.
        - Undersocres are discouraged, but not prohibited.
        - Examples:
            - `numpy`
            - `torchaudio`
            - `enterprise_assistant` (Not the best but allowed)

- Class names (PEP8):

    Class names should normally use the CapWords convention.

    - Examples:
        - `PdfReader`
        - `DataLoader`

- Function and Variable names (PEP8):

    - All-lowercase
    - Underscores can be used if it improves readability.
    - As informative as possible.
    - Functions should start with verb.
        - Examples:
            - `get_text_from_image()`
    - Boolean variables and functions should be written as a question in mixedCase.
        - Examples:
            - `isArray`.
            - `isEven()`

- Method names and instance variables (PEP8):

    - All-lowercase.
    - Underscores can be used if it improves readability.
    - Use one leading undersocre only for non-public methods and instance variables.
        - Examples:
            - `_non_public_variable`
            - `_non_public_method()`
    - As informative as possible.
    - Methods should start with verb.

- Constants (PEP8):

    - All-uppercase.
    - Underscores can be used if it improves readability.

- Bitbucket/Git branch names:

    - Code flow branches
        - Development: `dev`
        - QA/Test: `test`
        - Staging: `staging` (Optional)
        - Master: `master`

        Following this convention for the code flow branches, the desired code flow that any
        change should follow (except for hotfix) is: `temp_branch > dev > test > staging > master`

    - Temporary branches (using Bitbucket convention)

        The name of a temporary branch should have the following basic structure:
        `category/user/reference/description`

        - Category:
            - Feature: `feature/` -> Adding, refactoring or removing a feature
            - Bug fix: `bugfix/` -> Fixing a bug
            - Hot fix: `hotfix/` -> Changing code with a temporary solution directly to
            `master` (use only in case of emergency).
            - Experimental: `test/` -> Any new feature or idea that is not part of a
            release or sprint
            - Build: `build/` -> A branch specifically for creating specific build
            artifacts or for doing code coverage runs.
            - Release: `release/` -> A branch for tagging a specific release version.
            - Documentation: `docs/` -> A branch for documentation.

        - User:
            After the category, there should be a `/` followed by the initials of the
            user that created the branch.

        - Reference:
	        After the user initiales, there should be a `/` followed by an optional
	        reference of the Jira's issue/ticket you are working on. If there's
	        no reference, just ignore it.

        - Description:
            After the reference, there should be another `/` followed by a description
            which sums up the purpose of this specific branch. This description should
            be short and "kebab-cased".

        Example:
        ```bash
        $ git checkout -b "feature/aao/EAIFMX-13446/extract-text-images
        ```
        or:
        ```bash
        $ git checkout -b "feature/aao/implement-ocr"
        ```
