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

up: ## bring vagrant up
--- vagrant up

down: ## bring vagrant down
--- vagrant halt

destroy: ## destroy
--- vagrant destroy -f

bundle: Makefile Vagrantfile-* wp-provision* ## compress all the files into a .tgz
--- tar -czf all.tgz $^

deploy: bundle ## deploy to shrimp
--- rsync -tva --delete ./Makefile ./Vagrantfile-* ./wp-provision* ./all.tgz shrimp.vpn:/var/www/html/ansible/

clean: ## remove symlink and archive
--- rm -f Vagrantfile all.tgz

untar: ## extract the archive
--- tar -xvf all.tgz

get: ## get archive
--- wget https://hlmn.net/ansible/all.tgz -O all.tgz

.PHONY: help 0 1 2 up down destroy bundle deploy clean untar get
