# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make all        Run terraform and create targets.'
	@echo '    make terraform  Create or update GCP resources.'
	@echo '    make create     Create resources with bazel.'
	@echo '    make teardown   Destroy all GCP resources.'
	@echo '    make validate   Check that installed resources work as expected.'
	@echo '    make lint       Check syntax of all scripts.'
	@echo

# all
.PHONY: all
all: terraform create
	@echo "Done"

.PHONY: terraform
terraform:
	@source scripts/terraform.sh

.PHONY: create
create:
	@source scripts/create.sh

.PHONY: rbe-create
rbe-create:
	@source scripts/create-rbe.sh

.PHONY: validate
validate:
	@source scripts/validate.sh

.PHONY: teardown
teardown:
	@source scripts/teardown.sh

.PHONY: destroy_apps
destroy_apps:
	@source scripts/destroy_apps.sh

.PHONY: build
build:
	@bazel build //... --define cluster=dummy --define repo=gcr.io/foo \
		--incompatible_depset_union=false --incompatible_disallow_dict_plus=false  \
		--incompatible_depset_is_not_iterable=false --incompatible_new_actions_api=false
.PHONY: test
test:
	@bazel test //... --define cluster=dummy --define repo=gcr.io/foo \
		--incompatible_depset_union=false --incompatible_disallow_dict_plus=false  \
		--incompatible_depset_is_not_iterable=false --incompatible_new_actions_api=false

.PHONY: dev-server
dev-server:
	@bazel run //js-client/src:devserver --define cluster=dummy --define repo=gcr.io/foo \
		--incompatible_depset_union=false --incompatible_disallow_dict_plus=false  \
		--incompatible_depset_is_not_iterable=false --incompatible_new_actions_api=false
#####################################
# Linting for CI
######################################
.PHONY: lint
lint: check_shell check_shebangs check_python check_golang \
	check_docker check_base_files check_headers check_trailing_whitespace  check_terraform
# TODO (chrislovecnm): not supported yet
#
#check_java check_angular

.PHONY: check_shell
check_shell:
	@source test/make.sh && check_shell

.PHONY: check_python
check_python:
	@source test/make.sh && check_python

.PHONY: check_golang
check_golang:
	@source test/make.sh && golang

.PHONY: check_terraform
check_terraform:
	@source test/make.sh && check_terraform

.PHONY: check_docker
check_docker:
	@source test/make.sh && docker

.PHONY: check_base_files
check_base_files:
	@source test/make.sh && basefiles

.PHONY: check_shebangs
check_shebangs:
	@source test/make.sh && check_bash

.PHONY: check_trailing_whitespace
check_trailing_whitespace:
	@source test/make.sh && check_trailing_whitespace

.PHONY: check_headers
check_headers:
	@echo "Checking file headers"
	@python3.7 test/verify_boilerplate.py

.PHONY: check_java
check_java:
	@source test/make.sh && check_java

.PHONY: check_angular
check_angular:
	@source test/make.sh && check_angular
