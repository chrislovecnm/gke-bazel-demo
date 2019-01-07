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

PROJECT=$(gcloud config get-value project)
CONTEXT=$(kubectl config get-contexts -o=name | \
	grep "$PROJECT.*gke-bazel-tutorial")


function remove_apps(){
  echo "***********************************************************"
  echo "Deleting apps..."
  kubectl --namespace default --context="${CONTEXT}" \
    delete svc/"angular-client" deploy/"angular-client" 
  kubectl --namespace default --context="${CONTEXT}" \
    delete svc/"java-spring-boot" deploy/"java-spring-boot"  
  bazel clean --expunge
  sleep 180
  echo "done."
  echo "***********************************************************"
}


# LOCAL

remove_apps &>1 >> output.log 

echo -n "Timing local create..."

{ time make create; } &>1 >> output.log

echo "done."


# REMOTE

remove_apps &>1 >> output.log

echo -n "Timing remote create..."

{ RBE=true time make create; } &>1 >> output.log

echo "done."
