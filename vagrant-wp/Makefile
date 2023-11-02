# makefile template according to "your makefiles are wrong"
# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = ---

# add your own below this line

help: ## print what targets we've got
--- @grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

0:  ## Link Vagrantfile-0
--- ln -sf Vagrantfile-0 Vagrantfile

1:  ## Link Vagrantfile-1
--- ln -sf Vagrantfile-1 Vagrantfile

2:  ## Link Vagrantfile-2
--- ln -sf Vagrantfile-2 Vagrantfile

all: ## do all the things
--- @echo start every line with ---

up: ## bring vagrant up
--- vagrant up

down: ## bring vagrant down
--- vagrant halt

destroy: ## destroy
--- vagrant destroy -f

deploy: ## deploy to shrimp
--- rsync -tva ./Makefile ./Vagrantfile-* ./wp-provision* shrimp.vpn:/var/www/html/ansible/

.PHONY: all help 0 1 2 up down destroy
