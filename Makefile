#######################################
##### Makefile for Python-Project #####
#######################################

##################
## Set PROJET_PATH
##################
PROJECT_PATH=${PWD}

#######
## Init
#######
.PHONY: init
init: start-message project-info poetry-dev

################
## Init messages
################
start-message:
	@echo ""
	@echo "\033[1;39m#####################################\033[0m"
	@echo "\033[1;39m######### PYTHON - PROJECT ##########\033[0m"
	@echo "\033[1;39m#####################################\033[0m"
	@echo ""

project-info:
	@echo "Project: \033[1;33mCausal Lab AIF\033[0m"
	@echo "Author: \033[1;33mCausal Lab AIF team\033[0m"
	@echo "Description: \033[1;33m-\033[0m"
	@echo ""

#################
## Change version
#################
change-version: start-message
	@echo "\033[0;35m######################\033[0m"
	@echo "\033[0;35m##  CHANGE VERSION  ##\033[0m"
	@echo "\033[0;35m######################\033[0m"
ifdef version
	@old_version=$(shell cat pyproject.toml | awk '/^version =/{print $$3}' | xargs); \
	echo "Changing from version v$$old_version to v${version}..."; \
	cat pyproject.toml | awk '/^version =/{gsub($$3,"\"${version}\"")};{print}' > temp && mv temp pyproject.toml; \
	cat docs/design_doc.md | awk '/- Version:/{gsub($$3,"${version}")};{print}' > temp && mv temp docs/design_doc.md; \
	cat enterprise_assistant/__init__.py | awk '/^__version__ =/{gsub($$3,"\"${version}\"")};{print}' > temp && mv temp enterprise_assistant/__init__.py; \
	cat tests/test_enterprise_assistant.py | awk '/__version__ ==/{gsub($$4,"\"${version}\"")};{print}' > temp && mv temp tests/test_enterprise_assistant.py
	@echo ""
	@echo "\033[0;35m##################\033[0m"
	@echo "\033[0;35m##  DOC DEPLOY  ##\033[0m"
	@echo "\033[0;35m##################\033[0m"
	@echo "Deploying documentation for version v${version}"
	@poetry run mike deploy v${version}
	@poetry run mike set-default v${version}
	@echo ""
else
	@echo "\033[0;31mPlease set the version number:\033[0m \033[1;39m $$ make change-version version=<version_number>\033[0m"
	@echo ""
endif

#########
## Commit
#########
.PHONY: commit
commit: start-message pre-commit
	@echo "\033[0;35m##################\033[0m"
	@echo "\033[0;35m##  GIT COMMIT  ##\033[0m"
	@echo "\033[0;35m##################\033[0m"
	@echo "Running commitizen CHANGELOG.md update..."
	-poetry run cz changelog
	@git add .
	@echo ""
	@echo "Running comitizen commit..."
	@poetry run pre-commit run
	@poetry run cz commit
	@echo ""

################
## Documentation
################
.PHONY: docs
doc-deploy: start-message
	@echo "\033[0;35m##################\033[0m"
	@echo "\033[0;35m##  DOC DEPLOY  ##\033[0m"
	@echo "\033[0;35m##################\033[0m"
ifdef version
	@echo "Deploying documentation for version ${version}"
	@poetry run mike deploy v${version}
	@poetry run mike set-default v${version}
	@echo ""
else
	@version=$(shell cat pyproject.toml | awk '/^version =/{print $$3}' | xargs); \
	echo "Deploying documentation for version $$version"; \
	poetry run mike deploy v$$version; \
	poetry run mike set-default v$$version && echo "\033[0;32mDocumentation deployed successfully.\033[0m" || echo "\033[0;31mAn error has ocurred while deploying documentation\033[0m"
	@echo ""
endif

doc-serve: start-message
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[0;35m##  DOC SERVE  ##\033[0m"
	@echo "\033[0;35m#################\033[0m"
	@version=$(shell cat pyproject.toml | awk '/^version =/{print $$3}' | xargs); \
	echo "Deploying documentation for version $$version"; \
	poetry run mike deploy v$$version; \
	poetry run mike set-default v$$version; \
	echo "Deploying documentation in localhost..."; \
	poetry run mike serve
	@echo ""

#######################
## Jupyter Lab/Notebook
#######################
.PHONY: jupyter
jupyter-lab: start-message
	@echo "\033[0;35m###################\033[0m"
	@echo "\033[0;35m##  JUPYTER-LAB  ##\033[0m"
	@echo "\033[0;35m###################\033[0m"
	@echo "Deploying Jupyter-Lab in localhost..."
	@poetry run jupyter-lab
	@echo ""

jupyter-notebook: start-message
	@echo "\033[0;35m#######################\033[0m"
	@echo "\033[0;35m##  JUPYTER-NOTEBOOK ##\033[0m"
	@echo "\033[0;35m#######################\033[0m"
	@echo "Deploying Jupyter Notebook in localhost..."
	@poetry run jupyter notebook
	@echo ""

#########
## Poetry
#########
.PHONY: poetry
poetry-dev: pre-commit-install
	@echo "\033[0;35m#########################\033[0m"
	@echo "\033[0;35m##  POETRY INSTALL DEV ##\033[0m"
	@echo "\033[0;35m#########################\033[0m"
	@echo "Installing dependencies in Poetry environment..."
	@poetry config virtualenvs.path '${PROJECT_PATH}/.venv-dev' --local
	-poetry lock --no-update
	@poetry install
	@poetry export --format=requirements.txt --without-hashes > '${PROJECT_PATH}/requirements/common.txt'
	@poetry install --only dev,doc
	@poetry export --only dev --format=requirements.txt --without-hashes > '${PROJECT_PATH}/requirements/dev.txt'
	@poetry export --only doc --format=requirements.txt --without-hashes > '${PROJECT_PATH}/requirements/doc.txt'
	@echo ""
	@echo "\033[0;35m##########################\033[0m"
	@echo "\033[0;35m##  PRE-COMMIT INSTALL  ##\033[0m"
	@echo "\033[0;35m##########################\033[0m"
	@echo "Installing pre-commit..."
	@poetry run pre-commit install
	@echo ""
	@echo "\033[0;35m###################\033[0m"
	@echo "\033[0;35m##  POETRY SHELL ##\033[0m"
	@echo "\033[0;35m###################\033[0m"
	@echo "Entering Poetry environment shell..."
	@poetry shell
	@echo ""

poetry-prod: pre-commit-install
	@echo "\033[0;35m##########################\033[0m"
	@echo "\033[0;35m##  POETRY INSTALL PROD ##\033[0m"
	@echo "\033[0;35m##########################\033[0m"
	@echo "Installing dependencies in Poetry environment..."
	@poetry config virtualenvs.path '${PROJECT_PATH}/.venv-prod' --local
	@poetry install
	@poetry export --format=requirements.txt --without-hashes > '${PROJECT_PATH}/requirements/common.txt'
	@poetry install --only prod
	@poetry export --only prod --format=requirements.txt --without-hashes > '${PROJECT_PATH}/requirements/prod.txt'
	@echo ""
	@echo "\033[0;35m###################\033[0m"
	@echo "\033[0;35m##  POETRY SHELL ##\033[0m"
	@echo "\033[0;35m###################\033[0m"
	@echo "Entering Poetry environment shell..."
	@poetry shell
	@echo ""

poetry-remove: start-message
	@echo "\033[0;35m#####################\033[0m"
	@echo "\033[0;35m##  POETRY REMOVE  ##\033[0m"
	@echo "\033[0;35m#####################\033[0m"
	@echo "Removing Poetry environment $(shell poetry env list | awk '{print $$1}')..."
	@poetry env remove $(shell poetry env list | awk '{print $$1}')
	@rm -rf .venv*
	@echo "Poetry environment removed."
	@echo ""
	@echo "Removing poetry.lock..."
	@rm poetry.lock
	@echo "Poetry lock removed."
	@echo ""

#############
## Pre-commit
#############
.PHONY: pre-commit
pre-commit: start-message
	@echo "\033[0;35m##################\033[0m"
	@echo "\033[0;35m##  PRE-COMMIT  ##\033[0m"
	@echo "\033[0;35m##################\033[0m"
	@cd '${PROJECT_PATH}/'
	@git add .
	@pre-commit run
	@echo ""

pre-commit-install: start-message

##########
## Profile
##########
.PHONY: profile
profile: start-message
	@echo "\033[0;35m############################\033[0m"
	@echo "\033[0;35m##  PERFORMANCE ANALYSIS  ##\033[0m"
	@echo "\033[0;35m############################\033[0m"
ifdef prof
	@echo "Running CPU and memory profiling..."
	@poetry run python ${prof} > profiling/memory_profiler.log && echo "\033[0;32mProfiling log saved in profiling/memory_profiler.log.\033[0m" || echo "\033[0;31mError running performance anlaysis.\033[0m"
	@mv plot.png profiling/memory_profiler_plot.png
	@echo "\033[0;32mMemory and CPU usage reported in profiling/memory_profiler_plot.png.\033[0m"
	@echo ""
else
	@echo ""
	@echo "Please run define the prof parameter. Example: '$ make profile prof=profilings/profiling.py'"
	@echo ""
endif

##############
## Release Tag
##############
.PHONY: ta
tag: start-message
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[0;35m## TAG-VERSION ##\033[0m"
	@echo "\033[0;35m#################\033[0m"
ifdef version
	@echo "Fixing tag/version v${version} from current commit..." && (git tag -a v${version} -m "Bitbucket Reponame v${version}" && echo "\033[0;32mTag v${version} created\033[0m" && git push origin v${version}) || (echo "\033[0;31mERROR:\033[0m Listing all existing tags:" && git tag --list)
else
	@version=$(shell cat pyproject.toml | awk '/^version =/{print $$3}' | xargs); \
	echo "Fixing tag/version v$$version from current commit..." && (git tag -a v$$version -m "Bitbucket Reponame v$$version" && echo "\033[0;32mTag v$$version created\033[0m" && git push origin v$$version) || (echo "\033[0;31mERROR:\033[0m Listing all existing tags:" && git tag --list)
	@echo ""
endif

############
## Streamlit
############
.PHONY: streamlit
streamlit: start-message
	@echo "\033[0;35m#####################\033[0m"
	@echo "\033[0;35m##  STREAMLIT APP  ##\033[0m"
	@echo "\033[0;35m#####################\033[0m"
	@echo "Running Streamlit app..."
	@poetry run streamlit run app/app.py
	@echo ""

########
## Tests
########
.PHONY: test
test: start-message
	@echo "\033[0;35m#############\033[0m"
	@echo "\033[0;35m##  TESTS  ##\033[0m"
	@echo "\033[0;35m#############\033[0m"
	@echo "Running unit tests..."
	@poetry run coverage run -m pytest ${PROJECT_PATH}/tests/
	@poetry run coverage html -d docs/coverage --omit="*cache*"
	@echo ""

#############
## Virtualenv
#############
.PHONY: venv
venv-dev: start-message
	@echo "\033[0;35m####################\033[0m"
	@echo "\033[0;35m##  VENV INSTALL  ##\033[0m"
	@echo "\033[0;35m####################\033[0m"
	@echo "Installing dependencies in venv-dev environment..."
	@virtualenv '${PROJECT_PATH}/.venv-dev'
	@. '${PROJECT_PATH}/.venv-dev/bin/activate'
	@'${PROJECT_PATH}/.venv-dev/bin/pip' install -r requirements/common.txt
	@'${PROJECT_PATH}/.venv-dev/bin/pip' install -r requirements/dev.txt
	@echo ""
	@echo "\033[0;35m##########################\033[0m"
	@echo "\033[0;35m##  PRE-COMMIT INSTALL  ##\033[0m"
	@echo "\033[0;35m##########################\033[0m"
	@echo "Installing pre-commit..."
	@'${PROJECT_PATH}/.venv-dev/bin/pre-commit' install
	@echo ""
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[0;35m##  VENV SHELL ##\033[0m"
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[1;31mRemember to activate your environment by running:\033[0m"
	@echo ""
	@echo "\033[1;31m% . ${PROJECT_PATH}/.venv-dev/bin/activate\033[0m"
	@echo ""

venv-prod: start-message
	@echo "Setting up venv-prod environment..."
	@virtualenv '${PROJECT_PATH}/.venv-prod'
	@. '${PROJECT_PATH}/.venv-prod/bin/activate'
	@'${PROJECT_PATH}/.venv-prod/bin/pip' install -r requirements/common.txt
	@'${PROJECT_PATH}/.venv-prod/bin/pip' install -r requirements/prod.txt
	@echo ""
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[0;35m##  VENV SHELL ##\033[0m"
	@echo "\033[0;35m#################\033[0m"
	@echo "\033[1;31mRemember to activate your environment by running:\033[0m"
	@echo "\033[1;31m    % . ${PROJECT_PATH}/.venv-dev/bin/activate\033[0m"
	@echo ""

venv-remove: start-message
	@echo "\033[0;35m###################\033[0m"
	@echo "\033[0;35m##  VENV REMOVE  ##\033[0m"
	@echo "\033[0;35m###################\033[0m"
	@echo "Removing Virtualenv environment..."
	@rm -rf .venv*
	@echo "Virtualenv environment removed."
	@echo ""

#######
## Help
#######
.PHONY: help
help: start-message
	@echo "####################################################################"
	@echo "##                     MAKEFILE FOR PYTHON - PROJECT              ##"
	@echo "####################################################################"
	@echo ""
	@echo "   Targets:   "
	@echo ""
	@echo "   - init: Initialize repository and set Poetry environment"
	@echo "     - Check necessary paths and external dependencies"
	@echo "       Usage: % make"
	@echo ""
	@echo "   - commit: Perform Git commit using commitizen"
	@echo "       Usage: % make commit"
	@echo ""
	@echo "   - jupyter-lab: Starts Jupyter Lab"
	@echo "       Usage: % make jupyter-lab"
	@echo ""
	@echo "   - jupyter-notebook: Starts Jupyter Notebook"
	@echo "       Usage: % make jupyter-notebook"
	@echo ""
	@echo "   - poetry-dev: Initialize repo and set Poetry develop environment"
	@echo "       Usage: % make poetry-remove"
	@echo ""
	@echo "   - poetry-prod: Initialize repo and set Poetry production environment"
	@echo "       Usage: % make poetry-remove"
	@echo ""
	@echo "   - poetry-remove: Remove Poetry environment"
	@echo "       Usage: % make poetry-remove"
	@echo ""
	@echo "   - pre-commit: Run git add and pre-commit checks"
	@echo "       Usage: % make pre-commit"
	@echo ""
	@echo "   - profile: Run profilings"
	@echo "       Usage: % make profile"
	@echo ""
	@echo "   - tag: Release tag/version from current commit"
	@echo "       Usage: % make tag"
	@echo "       Usage: % make tag versin=X.X.X"
	@echo ""
	@echo "   - test: Run pytests and measure code coverage"
	@echo "       Usage: % make test"
	@echo ""
	@echo "   - venv-dev: Initialize repo and set Virtualenv develop environment"
	@echo "       Usage: % make venv-dev"
	@echo ""
	@echo "   - venv-prod: Initialize repo and set Virtualenv production environment"
	@echo "       Usage: % make venv-prod"
	@echo ""
	@echo "   - help: Display this menu"
	@echo "       Usage: % make help"
	@echo ""
	@echo "   - default: init"
	@echo ""
	@echo "   Hidden targets:"
	@echo "   "
	@echo "   - start-message"
	@echo "   - project-info"
	@echo "   "
	@echo "####################################################################"
