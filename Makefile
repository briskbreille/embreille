current_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

PATH_SEPARATOR?=/
rectify_path_separator=$(subst /,$(PATH_SEPARATOR),$(1))

VENV_DIR:=$(call rectify_path_separator,$(current_dir)venv.local/)
REQUIREMENTS_FILE_PATH:=$(call rectify_path_separator,$(current_dir)requirements.txt)
ENTRY_FILE_PATH:=$(call rectify_path_separator,$(current_dir)main.py)
DIST_DIR:=$(call rectify_path_separator,$(current_dir)dist/)
WORK_DIR:=$(call rectify_path_separator,$(current_dir)build/)

VIRTUALENV?=virtualenv
RM?=rm
PIP?=$(call rectify_path_separator,$(VENV_DIR)bin/pip)
PYINSTALLER?=$(call rectify_path_separator,$(VENV_DIR)bin/pyinstaller)
PYTHON?=$(call rectify_path_separator,$(VENV_DIR)bin/python)

default: dev
.PHONY: default

dev: update_requirements
	$(PYTHON) $(ENTRY_FILE_PATH)
.PHONY: update_requirements

build: install_requirements
	$(PYINSTALLER) -y --distpath $(DIST_DIR) --workpath $(WORK_DIR) $(ENTRY_FILE_PATH)
.PHONY: build

clean:
	$(RM) -rf $(WORK_DIR) $(DIST_DIR)
.PHONY: clean

install_requirements: $(REQUIREMENTS_FILE_PATH) $(VENV_DIR)
	$(PIP) install -r $<
.PHONY: install_requirements

update_requirements: $(VENV_DIR)
	$(PIP) freeze > $(REQUIREMENTS_FILE_PATH)
.PHONY: dump_requirements

$(VENV_DIR):
	$(VIRTUALENV) $@
