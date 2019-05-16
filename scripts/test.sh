#! /usr/bin/env bash

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

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Creates cluster and deploys demo application         -"
# "-                                                       -"
# "---------------------------------------------------------"
set -o errexit
set -o nounset
set -o pipefail
set -x

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# shellcheck source=/dev/null
source "$ROOT/scripts/common.sh"

PROJECT=$(gcloud config get-value project)
# dummy value
CONTEXT="FOO"
REPO=gcr.io/$PROJECT

#########################
# RBE setup (if enabled)
# (See DEVELOPER.md)
#########################

# If you want to enable RBE, set it when calling `make create`
# Any non-false value will enable RBE options (ex: RBE=true make create)
RBE="${RBE:-false}"

if  [[ $RBE != false ]]; then
	# Issue some warnings about RBE on GCP
	echo -e "\\n*************************************************************\\n\
WARNING: GCP RBE support is in Alpha. DO NOT USE IN PRODUCTION.\\n\
See README for instructions on setting up RBE support in this demo.\\n\
*************************************************************\\n"

  # if RBE, gcloud needs alpha component
  #  gcloud components install alpha

  # if RBE, enable API (this also creates default_instance)
  # gcloud services enable remotebuildexecution.googleapis.com \
  #  "--project=$PROJECT"

  # if RBE, create a worker pool, if one doesn't exist
	POOL_LIST=$(gcloud alpha remote-build-execution worker-pools list \
		 --instance=default_instance)

	if [[ ! "$POOL_LIST" =~ "state: RUNNING" ]]; then
		echo -n "Creating an RBE worker pool..."

		POOL_NAME="$PROJECT-rbe-pool"
		gcloud alpha remote-build-execution worker-pools create \
			"${POOL_NAME:0:50}" \
			--instance=default_instance \
			--worker-count=3 \
			--machine-type=n1-standard-2 \
			--disk-size=50

		echo "done."
	else
		echo "Using the existing RBE worker pool."
	fi
fi


##################
# Test with bazel
##################

# TODO - update this to run on //...
# Use Bazel to test
TEST_CMD=(bazel test
  --define "cluster=${CONTEXT}"
  --define "repo=${REPO}"
  //js-client/...)

if [[ $RBE != false ]]; then
  TEST_CMD=(bazel 
    --bazelrc bazel-0.25.0.bazelrc
    test
    --config remote
    --define "cluster=${CONTEXT}"
    --define "repo=${REPO}"
    //js-client/...)
	echo "Running remote TEST_CMD = ${TEST_CMD[*]}"
fi

# if on a mac use planter
if [[ "$OSTYPE" == "darwin"* ]]; then
	# shellcheck source=/dev/null
	source "$ROOT/scripts/planter.sh" "${TEST_CMD[*]}"
else
	"${TEST_CMD[@]}"
fi
