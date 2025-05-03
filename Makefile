current_dir:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

EXECUTABLE_NAME?=app

VENV_DIR:=$(current_dir)venv.local/
REQUIREMENTS_FILE_PATH:=$(current_dir)requirements.txt
ENTRY_FILE_PATH:=$(current_dir)main.py
DIST_DIR:=$(current_dir)dist/
WORK_DIR:=$(current_dir)build/

VIRTUALENV=virtualenv
RM=rm

pip=$(firstword $(wildcard $(VENV_DIR)bin/pip*))
python=$(firstword $(wildcard $(VENV_DIR)bin/python*))
pyinstaller=$(firstword $(wildcard $(VENV_DIR)bin/pyinstaller*))

default: dev
.PHONY: default

dev: update_requirements
	$(call python) $(ENTRY_FILE_PATH)
.PHONY: update_requirements

build: install_requirements
	$(call pyinstaller) -y --windowed --name $(EXECUTABLE_NAME) --distpath $(DIST_DIR) --workpath $(WORK_DIR) $(ENTRY_FILE_PATH)
.PHONY: build

clean:
	$(RM) -rf $(WORK_DIR) $(DIST_DIR)
.PHONY: clean

install_requirements: $(REQUIREMENTS_FILE_PATH) $(VENV_DIR)
	$(call pip) install -r $<
.PHONY: install_requirements

update_requirements: $(VENV_DIR)
	$(call pip) freeze > $(REQUIREMENTS_FILE_PATH)
.PHONY: dump_requirements

$(VENV_DIR):
	$(VIRTUALENV) $@
