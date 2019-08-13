#!/usr/bin/env groovy
/*
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Reference: https://github.com/jenkinsci/kubernetes-plugin
// set up pod label and GOOGLE_APPLICATION_CREDENTIALS (for Terraform)
def containerName = "bazel"
def GOOGLE_APPLICATION_CREDENTIALS = '/home/jenkins/dev/jenkins-deploy-dev-infra.json'
// @chrislovcnm TODO - update env.JENKINS_CONTAINER_VERSION once enterprise // demo is building as well.
def jenkins_container_version = "28bac2b"

podTemplate(
        containers: [
                containerTemplate(name: "${containerName}",
                        image: "gcr.io/pso-helmsman-cicd/jenkins-k8s-node:${jenkins_container_version}",
                        command: 'tail -f /dev/null',
                        resourceRequestCpu: '4000m',
                        resourceLimitCpu: '6000m',
                        resourceRequestMemory: '2Gi',
                        resourceLimitMemory: '6Gi'
                )
        ],
        volumes: [secretVolume(mountPath: '/home/jenkins/dev',
                secretName: 'jenkins-deploy-dev-infra'
        )]
) {
    node(POD_LABEL) {
        try {
            // set env variable GOOGLE_APPLICATION_CREDENTIALS for Terraform
            env.GOOGLE_APPLICATION_CREDENTIALS = GOOGLE_APPLICATION_CREDENTIALS

            stage('Setup') {
                container(containerName) {
                    // checkout code from scm i.e. commits related to the PR
                    checkout scm

                    // Setup gcloud service account access
                    sh "gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}"
                    sh "gcloud config set compute/zone ${env.ZONE}"
                    sh "gcloud config set core/project ${env.PROJECT_ID}"
                    sh "gcloud config set compute/region ${env.REGION}"
                }
            }
            stage('Lint') {
                container(containerName) {
                    sh "make lint"
                }
            }
            stage('Bazel') {
                container(containerName) {
                    sh """bazel build //... --define cluster=dummy --define repo=gcr.io/${env.PROJECT_ID} \\
                          --incompatible_depset_union=false --incompatible_disallow_dict_plus=false  \\
                          --incompatible_depset_is_not_iterable=false --incompatible_new_actions_api=false"""
                }
            }
            stage('Terraform') {
                container(containerName) {
                    sh "make terraform"
                }
            }
            stage('Create') {
                container(containerName) {
                    sh 'make create'
                }
            }
            stage('Validate') {
                container(containerName) {
                    sh 'make validate'
                }
            }
        } catch (err) {
            // if any exception occurs, mark the build as failed
            // and display a detailed message on the Jenkins console output
            currentBuild.result = 'FAILURE'
            echo "FAILURE caught echo ${err}"
            throw err
        } finally {
            stage('Teardown') {
                container(containerName) {
                    sh "make teardown"
                }
            }
        }
    }
}
