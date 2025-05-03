current_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

EXECUTABLE_NAME?=app
VIRTUAL_ENV_POLICY?=yes

REQUIREMENTS_FILE_PATH:=$(current_dir)requirements.txt
ENTRY_FILE_PATH:=$(current_dir)main.py
DIST_DIR:=$(current_dir)dist/
WORK_DIR:=$(current_dir)build/

RM:=rm
PIP:=pip
PYTHON:=python
PYINSTALLER:=pyinstaller

ifeq ($(VIRTUAL_ENV_POLICY),yes)
ifeq ($(VIRTUAL_ENV),)
$(error Use a virtual environment, you can circumvent this error by setting `VIRTUAL_ENV_POLICY` to `no`)
endif
endif

default: dev
.PHONY: default

install_requirements: $(REQUIREMENTS_FILE_PATH)
	$(PIP) install -r $<
.PHONY: install_requirements

update_requirements:
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
