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

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# shellcheck source=/dev/null
source "$ROOT/scripts/common.sh"

PROJECT=$(gcloud config get-value project)
CONTEXT=$(kubectl config get-contexts -o=name | \
	grep "$PROJECT.*gke-bazel-tutorial")
REPO=gcr.io/$PROJECT

## Enabling docker gcp helper
gcloud auth configure-docker

##################
# Deploy Ingress
##################

# Use Bazel to compile, build, and deploy the Java Spring Boot API
CMD=(bazel 
     --bazelrc bazel-0.25.0.bazelrc
     run
     "--incompatible_disallow_dict_plus=false"
     --config remote
     --define "cluster=${CONTEXT}"
     --define "repo=${REPO}"
     //ingress:k8s.apply)

if [[ $RBE != false ]]; then
	CMD+=("${RBE_FLAGS[@]}")
	echo "Running remote JAVA_CMD = ${JAVA_CMD[*]}"
fi

# RBE can't run on mac yet
if [[ $RBE != false || "$OSTYPE" == "darwin"* ]]; then
	# shellcheck source=/dev/null
	source "$ROOT/scripts/planter.sh" "${CMD[*]}"
else
	"${CMD[@]}"
fi

##################
# Deploy Demo
##################

# Use Bazel to compile, build, and deploy the Java Spring Boot API
CMD=(bazel
  --bazelrc bazel-0.25.0.bazelrc
  run
  "--incompatible_disallow_dict_plus=false"
  --config remote
  --define "cluster=${CONTEXT}"
  --define "repo=${REPO}"
  //:bazel_demo_k8s.apply)

# RBE can't run on mac yet
if [[ $RBE != false || "$OSTYPE" == "darwin"* ]]; then
	# shellcheck source=/dev/null
	source "$ROOT/scripts/planter.sh" "${CMD[*]}"
else
	"${CMD[@]}"
fi

#########
# Output
#########

# output the IP address of the angular app service to view in browser
echo -n "Waiting for Angular service to setup endpoints..."
for _ in {1..60}; do
  ANGULAR_IP=$(kubectl --namespace default --context="${CONTEXT}" \
    get svc -lapp=angular-client -o jsonpath='{..ip}')
  if [[ $ANGULAR_IP =~ [(0-9)+\.]{4} ]]; then
    echo "done."
    break
  fi
  sleep 2
done

# handle timeout
if [ -z "$ANGULAR_IP" ]; then
	echo -e "Getting the Angular client IP address timed out.\\n\
Check on the service and re-run 'make create'."
	exit 1
fi

echo "View your angular client at http://${ANGULAR_IP}"
