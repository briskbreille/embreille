current_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

EXECUTABLE_NAME?=app

REQUIREMENTS_FILE_PATH:=$(current_dir)requirements.txt
ENTRY_FILE_PATH:=$(current_dir)main.py
DIST_DIR:=$(current_dir)dist/
WORK_DIR:=$(current_dir)build/

RM:=rm
PIP:=pip
PYTHON:=python
PYINSTALLER:=pyinstaller

default: dev
.PHONY: default

install_requirements: $(REQUIREMENTS_FILE_PATH) $(VENV_DIR)
	$(PIP) install -r $<
.PHONY: install_requirements

update_requirements: $(VENV_DIR)
	$(PIP) freeze > $(REQUIREMENTS_FILE_PATH)
.PHONY: update_requirements

clean:
	$(RM) -rf $(WORK_DIR) $(DIST_DIR)
.PHONY: clean

dev: install_requirements update_requirements
	$(PYTHON) $(ENTRY_FILE_PATH)
.PHONY: update_requirements

build: install_requirements update_requirements
	$(PYINSTALLER) --windowed -y --name $(EXECUTABLE_NAME) --distpath $(DIST_DIR) --workpath $(WORK_DIR) $(ENTRY_FILE_PATH)
.PHONY: build

$(VENV_DIR):
	$(VIRTUALENV) $@
