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
# "-  Validation script checks if demo application         -"
# "-  deployed successfully.                               -"
# "-                                                       -"
# "---------------------------------------------------------"

# Do not set exit on error, since the rollout status command may fail
set -o nounset
set -o pipefail

CONTEXT=$(kubectl config get-contexts -o=name | grep "$(gcloud config get-value project).*gke-bazel-tutorial")

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# shellcheck source=/dev/null
source "$ROOT/scripts/common.sh"

# shellcheck source=/dev/null
cd "$ROOT/terraform" || exit; CLUSTER_NAME=$(terraform output cluster_name) \
  ZONE=$(terraform output primary_zone)

# Get credentials for the k8s cluster
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone="$ZONE"

# Check rollout status of the JS client
JS_APP_NAME=$(kubectl get deployments -n default \
  -ojsonpath='{.items[0].metadata.labels.app}')
JS_APP_MESSAGE="deployment \"$JS_APP_NAME\" successfully rolled out"

SUCCESSFUL_ROLLOUT=false
for _ in {1..30}; do
  ROLLOUT=$(kubectl rollout status -n default \
    --watch=false deployment/"$JS_APP_NAME") &> /dev/null
  if [[ $ROLLOUT = *"$JS_APP_MESSAGE"* ]]; then
    SUCCESSFUL_ROLLOUT=true
    break
  fi
  sleep 2
done

if [ "$SUCCESSFUL_ROLLOUT" = false ]; then
  echo "ERROR - $JS_APP_NAME failed to deploy"
  exit 1
else
  echo "$JS_APP_NAME successfully deployed"
fi


# Check rollout status of the Java API
JAVA_APP_NAME=$(kubectl get deployments -n default \
  -ojsonpath='{.items[1].metadata.labels.app}')
JAVA_APP_MESSAGE="deployment \"$JAVA_APP_NAME\" successfully rolled out"

SUCCESSFUL_ROLLOUT=false
for _ in {1..30}; do
  ROLLOUT=$(kubectl rollout status -n default \
    --watch=false deployment/"$JAVA_APP_NAME") &> /dev/null
  if [[ $ROLLOUT = *"$JAVA_APP_MESSAGE"* ]]; then
    SUCCESSFUL_ROLLOUT=true
    break
  fi
  sleep 2
done

if [ "$SUCCESSFUL_ROLLOUT" = false ]; then
  echo "ERROR - $JAVA_APP_NAME failed to deploy"
  exit 1
else
  echo "$JAVA_APP_NAME successfully deployed"
fi

ING_IP=$(kubectl --namespace default --context="${CONTEXT}" \
    get ingress -lapp=bazel-demo -o jsonpath='{..ip}')

if [[ $ING_IP =~ [(0-9)+\.]{4} ]]; then
    echo "found ingress ip: ${ING_IP}"
else
  echo "error finding ingress ip address"
  exit 1
fi

# it can take awhile for an ingress to start, so we need to wait awhile
# and test multiple times
for _ in {1..40}; do
  # curl angular endpoint
  ANGULAR_STATUS=$(curl -o /dev/null -s -w "%{http_code}\\n" "$ING_IP")
  if [ "$ANGULAR_STATUS" == 200 ]; then
    echo "The Angular app is reachable."
    break
  fi
  sleep 30
  echo "Waiting for ingress to become ready."
done

if [ "$ANGULAR_STATUS" == 200 ]; then
    echo "The Angular app is reachable."
else
    echo "The Angular app has a problem, returned status $ANGULAR_STATUS"
    exit 1
fi

# run Java API tests
# shellcheck source=/dev/null
source "$ROOT/scripts/java-spring-boot-tests.sh" "$ING_IP"
