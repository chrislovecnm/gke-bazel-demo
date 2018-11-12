# Building & Deploying with Bazel on Kubernetes Engine

## Table of Contents
* [Introduction](#introduction)
* [Architecture](#architecture)
* [Prerequisites](#prerequisites)
  * [Cloud Project](#cloud-project)
  * [Install Cloud SDK](#install-cloud-sdk)
  * [Install Kubectl](#install-kubectl)
  * [Install Terraform](#install-terraform)
  * [Configure Authentication](#configure-authentication)
  * [Install Java](#install-java)
  * [Install Bazel](#install-bazel)
* [Deployment](#deployment)
  * [Create the cluster](#create-the-cluster)
  * [Build & deploy with Bazel](#build-deploy-with-bazel)
* [Validation](#validation)
* [Teardown](#teardown)
* [Troubleshooting](#troubleshooting)
* [Relevant Material](#relevant-material)


## Introduction
[Bazel](http://bazel.build) is a scalable, extensible build system developed and open-sourced by Google. It can build a large variety of programming languages at scale by leveraging distributed caching, dependency analysis, parrallel execution, and remote build capabilities.

One of the many extensions written for Bazel is [a suite of rules to use with Kubernetes](https://github.com/bazelbuild/rules_k8s), which makes Bazel a prime candidate to use in your CI/CD pipeline to build your applications from source code, create containers for updated builds, and deploy them to a Kubernetes cluster. This tutorial will demonstrate how to leverage Bazel in such a fashion, using GKE as our Kubernetes cluster provider.

This tutorial also uses [Terraform](https://www.terraform.io/) to setup and teardown the GKE Kubernetes cluster.

## Architecture

The tutorial will create a Kubernetes Engine cluster with 1 node, and 1 pod deployed to the cluster. The pod has 2 containers, one for a Javascript SPA client that makes a request to the other container, a Java servlet with a simple REST API endpoint.

Bazel is used to build each of the containers from source, register the containers in GCR, and then deploy the containers as a pod deployment & service on your GKE cluster.

## Prerequisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

### Cloud Project

You'll need access to a Google Cloud Project with billing enabled. See [Creating and Managing Projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier it's recommended to create a new project.

### Install Cloud SDK

The Google Cloud SDK is used to interact with your GCP resources. [Installation instructions](https://cloud.google.com/sdk/downloads) for multiple platforms are available online.

### Install Kubectl

Once you have the Google Cloud SDK installed we can use it to install Kubectl.
This is accomplished by executing the following command:

```console
$ gcloud components install kubectl
```

### Install Terraform

Terraform is used to automate the manipulation of cloud infrastructure. Its [installation instructions](https://www.terraform.io/intro/getting-started/install.html) are also available online.

### Configure Authentication

The Terraform configuration will execute against your GCP environment and create a Kubernetes Engine cluster running a simple application.  The configuration will use your personal account to build out these resources.  To setup the default account the configuration will use, run the following command to select the appropriate account:

```console
$ gcloud auth application-default login
```

### Install Java

Follow directions for your platform to [install Java 1.8](https://www.java.com/en/download/help/download_options.xml). For many platforms, you can use a package manager to install it.

### Install Bazel

After installing Java, follow directions for your platform to [install Bazel](https://docs.bazel.build/versions/master/install.html). For many platforms, you can use a package manager to install it.

## Deployment

### Create the cluster

The infrastructure required by this project can be deployed by executing:
```console
make terraform
```

This will:
1. Enable any APIs we need and verify our prerequisites are met.
2. Read your project & zone configuration to generate the following config file:
  * `./terraform/terraform.tfvars` for Terraform variables
3. Run `terraform init` to prepare Terraform to create the infrastructure
4. Run `terraform apply` to actually create the cluster with 1 node

If you need to override any of the defaults in the Terraform variables file, simply replace the desired value(s) to the right of the equals sign(s). Be sure your replacement values are still double-quoted.

If no errors are displayed then after a few minutes you should see your Kubernetes Engine cluster in the [GCP Console](https://console.cloud.google.com/kubernetes).

### Build & deploy with Bazel

To use Bazel to deploy our applications run:
```console
make create
```

This will:
1. sdkfj
2. skdfj
3. sldkf

## Validation

TODO

## Teardown

When you are finished with this example, and you are ready to clean up the resources that were created so that you avoid accruing charges, you can run the following Terraform command to remove all resources :

```
$ terraform destroy
```

Terraform tracks the resources it creates so it is able to tear them all back down.

## Troubleshooting

** The install script fails with a `Permission denied` when running Terraform.**
The credentials that Terraform is using do not provide the
necessary permissions to create resources in the selected projects. Ensure
that the account listed in `gcloud config list` has necessary permissions to
create resources. If it does, regenerate the application default credentials
using `gcloud auth application-default login`.

## Relevant Material
* [Terraform Google Cloud Provider](https://www.terraform.io/docs/providers/google/index.html)
* [Bazel](http://bazel.build)
* [Bazel Docker rules](https://github.com/bazelbuild/rules_docker)
* [Bazel k8s rules](https://github.com/bazelbuild/rules_k8s)


**This is not an officially supported Google product**
