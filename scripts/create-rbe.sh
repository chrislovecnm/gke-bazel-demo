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

#########################
# RBE setup (if enabled)
# (See DEVELOPER.md)
#########################


#if  [[ $RBE != false ]]; then
#	# Issue some warnings about RBE on GCP
#	echo -e "\\n*************************************************************\\n\
#WARNING: GCP RBE support is in Alpha. DO NOT USE IN PRODUCTION.\\n\
#See README for instructions on setting up RBE support in this demo.\\n\
#*************************************************************\\n"

#	# if RBE, add remote config to .bazelrc
#	cp ".bazelrc.remote" ".bazelrc"

	# if RBE, gcloud needs alpha component
#	gcloud components install alpha

  # if RBE, enable API (this also creates default_instance)
#  gcloud services enable remotebuildexecution.googleapis.com \
#    "--project=$PROJECT"

  # if RBE, create a worker pool, if one doesn't exist
#	POOL_LIST=$(gcloud alpha remote-build-execution worker-pools list \
#		 --instance=default_instance)

#	if [[ ! "$POOL_LIST" =~ "state: RUNNING" ]]; then
#		echo -n "Creating an RBE worker pool..."

#		POOL_NAME="$PROJECT-rbe-pool"
#		gcloud alpha remote-build-execution worker-pools create \
#			"${POOL_NAME:0:50}" \
#			--instance=default_instance \
#			--worker-count=3 \
#			--machine-type=n1-standard-2 \
#			--disk-size=50
#
#		echo "done."
#	else
#		echo "Using the existing RBE worker pool."
#	fi
#fi


##################
# Deploy Java API
##################

# Use Bazel to compile, build, and deploy the Java Spring Boot API
JAVA_CMD=(bazel
  --bazelrc=bazel-0.25.0.bazelrc
  run
  --config remote
  --define "cluster=${CONTEXT}"
  --define "repo=${REPO}"
  //java-spring-boot:k8s.apply)

echo "Running remote JAVA_CMD = ${JAVA_CMD[*]}"

##############################
# Update Angular API endpoint
##############################

# make sure Angular is talking to the deployed Java API, not local
echo -n "Waiting for Java service to setup endpoints..."
for _ in {1..60}; do
  API_IP=$(kubectl --namespace default --context="${CONTEXT}" \
    get svc -lapp=java-spring-boot -o jsonpath='{..ip}')
  if [[ $API_IP =~ [(0-9)+\.]{4} ]]; then
		echo "done."
    break
  fi
  sleep 2
done

# handle timeout
if [ -z "$API_IP" ]; then
	echo -e "Getting the Java API IP address timed out.\\n\
Check on the service and re-run 'make create'."
	exit 1
fi

sed -i.bak -e "s/localhost:8080/${API_IP}/g" \
	"js-client/src/todos/todos.service.ts"

echo "Updated Angular client to speak to ${API_IP}"


########################
# Deploy Angular Client
########################

# Use Bazel to compile, build, and deploy the Angular client
JS_CMD=(bazel
  --bazelrc=bazel-0.25.0.bazelrc
  run
  --config remote
  --define "cluster=${CONTEXT}"
  --define "repo=${REPO}"
  //js-client:k8s.apply)

#JS_CMD+=("${RBE_FLAGS[@]}")
echo "Running remote JS_CMD = ${JS_CMD[*]}"

# shellcheck source=/dev/null
source "$ROOT/scripts/planter.sh" "${JS_CMD[@]}"

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


##########
# Cleanup
##########

# put js-client/src/todos/todos.service.ts back to original API (localhost)
mv "js-client/src/todos/todos.service.ts.bak" \
	 "js-client/src/todos/todos.service.ts"
