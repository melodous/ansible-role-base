APP                = ansible-role-base
ROOT               = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REQ                = requirements.txt
VIRTUALENV         ?= $(shell which virtualenv)
PYTHON             ?= $(shell which python2.7)
PIP                ?= $(shell which pip2.7)
MOLECULE_PROVIDER  = virtualbox
VENV               ?= $(ROOT)/.venv
PLATFORMS          = rhel7

.ONESHELL:
.PHONY: test test_rhel6 test_rhel7 clean venv $(VENV)

all: default

default:
	@echo
	@echo "Welcome to '$(APP)' software package:"
	@echo
	@echo "usage: make <command>"
	@echo
	@echo "commands:"
	@echo "    clean                           - Remove generated files and directories"
	@echo "    venv                            - Create and update virtual environments"
	@echo "    test PLATFORM=($(PLATFORMS))    - Run test on specified platform"
	@echo "    del PLATFORM=($(PLATFORMS))     - Remove specified platform"
	@echo "    ansiblelint                     - Run ansible-lint validations
	@echo "    yamllint                        - Run yamlint validations
	@echo

venv: $(VENV)

$(VENV): $(REQ)
	@echo ">>> Initializing virtualenv..."
	mkdir -p $@; \
	[ -z "$$VIRTUAL_ENV" ] && $(VIRTUALENV)  --no-site-packages  --distribute -p $(PYTHON) $@; \
	$@/bin/pip install --exists-action w -r $(REQ);
	@echo && echo && echo && echo

ansiblelint: venv
	@echo ">>> Executing ansible lint..."
	@[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	ansible-lint -r ansible-lint -r $(VENV)/lib/python2.7/site-packages/ansiblelint/rules playbook.yml
	@echo

yamllint: venv
	@echo ">>> Executing yaml lint..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	yamllint tasks/* vars/* defaults/* meta/* handlers/*
	@echo

lint: yamllint ansiblelint

delete:
	@echo ">>> Deleting $(PLAFORM) ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule destroy --platform=$(PLATFORM);
	@echo

test: venv
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	PYTEST_ADDOPTS="--junit-xml junit-$(PLATFORM).xml --ignore roles/$(APP)" molecule test --platform=$(PLATFORM);
	@echo

create:
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule create --platform=$(PLATFORM);
	@echo

converge:
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule create --platform=$(PLATFORM);
	@echo

syntax: venv
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule syntax;
	@echo

idempotence:
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	molecule idempotence --platform=$(PLATFORM);
	@echo

verify:
	@echo ">>> Runing $(PLAFORM) tests ..."
	[ -z "$$VIRTUAL_ENV" ] && source $(VENV)/bin/activate; \
	PYTEST_ADDOPTS="--junit-xml junit-$(PLATFORM).xml --ignore roles/$(APP)" molecule verify --platform=$(PLATFORM);
	@echo



clean:
	@echo ">>> Cleaning temporal files..."
	rm -rf .cache/
	rm -rf $(VENV)
	rm -rf junit-*.xml
	rm -rf tests/__pycache__/
	rm -rf .vagrant/
	rm -rf .molecule/
	@echo
