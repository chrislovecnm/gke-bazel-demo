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

# We have build at times using a container on OSX
# See https://github.com/bazelbuild/rules_nodejs/issues/396

if [ -z "$1" ]; then
  echo "Need to call scripts/planter.sh with a command you want to run."
  exit 1
fi

command -v docker >/dev/null 2>&1 || { \
 echo >&2 "Planter requires docker but it's not installed. Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { \
 echo >&2 "Script requires curl but it's not installed. Aborting."; exit 1; }

PLANTER_SHA=2739d2866b9c4d6c45f1281a6fc4c501bde24695
PLANTER_URL="https://raw.githubusercontent.com/kubernetes/test-infra/${PLANTER_SHA}/planter/planter.sh"
PLANTER_PATH="$ROOT/planter"

# download planter repo archive to use Bazel, so CI will work
if [ ! -f "$PLANTER_PATH/planter.sh" ]; then
	echo -n "Downloading planter..."

  curl -sL "${PLANTER_URL}" \
    --output "$ROOT/planter/planter.sh"
  chmod +x "$ROOT/planter/planter.sh"
  echo "Downloaded planter"
else
  echo "Already downloaded planter, so skipping download."
fi

docker_extra="-v ${HOME}/.npm:${HOME}/.npm:delegated"
docker_extra+=" -v ${HOME}/.kube:${HOME}/.kube:delegated"
docker_extra+=" -v ${HOME}/.config:${HOME}/.config:delegated"
docker_extra+=" -v ${HOME}/.docker:${HOME}/.docker:delegated"

IMAGE=gcr.io/pso-examples/planter-kubectl:0.24.0 \
DOCKER_EXTRA="${docker_extra}" "$PLANTER_PATH/planter.sh" "$@"
