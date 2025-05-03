current_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

PATH_SEPARATOR?=/
rectify_path_separator=$(subst /,$(PATH_SEPARATOR),$(1))

VENV_DIR:=$(current_dir)venv.local/
REQUIREMENTS_FILE_PATH:=$(current_dir)requirements.txt
ENTRY_FILE_PATH:=$(current_dir)main.py
DIST_DIR:=$(current_dir)dist/
WORK_DIR:=$(current_dir)build/

VIRTUALENV?=virtualenv
RM?=rm
PIP?=$(VENV_DIR)bin/pip
PYINSTALLER?=$(VENV_DIR)bin/pyinstaller
PYTHON?=$(VENV_DIR)bin/python

default: dev
.PHONY: default

dev: update_requirements
	$(PYTHON) $(call rectify_path_separator,$(ENTRY_FILE_PATH))
.PHONY: update_requirements

build: install_requirements
	$(PYINSTALLER) -y --distpath $(call rectify_path_separator,$(DIST_DIR)) --workpath $(call rectify_path_separator,$(WORK_DIR)) $(call rectify_path_separator,$(ENTRY_FILE_PATH))
.PHONY: build

clean:
	$(RM) -rf $(call rectify_path_separator,$(WORK_DIR)) $(call rectify_path_separator,$(DIST_DIR))
.PHONY: clean

install_requirements: $(REQUIREMENTS_FILE_PATH) $(VENV_DIR)
	$(PIP) install -r $(call rectify_path_separator,$<)
.PHONY: install_requirements

update_requirements: $(VENV_DIR)
	$(PIP) freeze > $(call rectify_path_separator,$(REQUIREMENTS_FILE_PATH))
.PHONY: dump_requirements

$(VENV_DIR):
	$(VIRTUALENV) $(call rectify_path_separator,$@)
