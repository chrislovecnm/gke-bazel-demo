# Building & Deploying with Bazel on Kubernetes Engine

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?git_repo=https%3A%2F%2Fgithub.com%2FGoogleCloudPlatform%2Fhelmsman-gke-bazel-demo.git&page=editor&tutorial=README.md&open_in_editor=.)

[Signup for a free Google Cloud account](https://cloud.google.com/)

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
    * [K8s Rules](#k8s-rules)
* [Validation](#validation)
* [Teardown](#teardown)
* [Troubleshooting](#troubleshooting)
* [Relevant Material](#relevant-material)


## Introduction
[Bazel](http://bazel.build) is a scalable, extensible build system developed and open-sourced by Google. It can build a large variety of programming languages at scale by leveraging distributed caching, dependency analysis, parrallel execution, and remote caching & execution.

One of the many extensions written for Bazel is [a suite of rules to use with Kubernetes](https://github.com/bazelbuild/rules_k8s), which makes Bazel a prime candidate to use in your CI/CD pipeline to build your applications from source code, create containers for updated builds, and deploy them to a Kubernetes cluster. This tutorial will demonstrate how to leverage Bazel in such a fashion, using GKE as our Kubernetes cluster provider.

This tutorial also uses [Terraform](https://www.terraform.io/) to setup and teardown the GKE Kubernetes cluster.

Also be sure to read DEVELOPER.md for a more technical introduction, along with background and work-in-progress context for this demo.

## Architecture

The tutorial will create a Kubernetes Engine cluster with 1 node, and 2 pods deployed to the cluster. One pod has an Angular SPA client (based off [Alex Eagle's Angular Bazel demo](https://github.com/alexeagle/angular-bazel-example), see [Alex's Bazelconf talk as well](https://youtu.be/yBg9zG6ZGb4)) that makes a request to the other pod, a Java Spring Boot app that provides a simple REST API endpoint. The deployment also creates services for both deployments to expose the client and API.

Bazel is used to build each of the containers from source, register the containers in GCR, and then deploy the containers as a pod deployment & service on your GKE cluster.

![deployed architecture](/images/DeployedArchitecture.png)

See DEVELOPER.md for a more detailed explanation on how Bazel targets & packages are structured.

Here's a graph of what happens in Bazel when we call the Bazel command to deploy the Java API:

![deployed architecture](/images/BazelJavaBuildTree.png)

Here's a graph of what happens in Bazel when we call the Bazel command to deploy the JS Client:

![deployed architecture](/images/BazelJSClientBuildTree.png)

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

The Terraform configuration will execute against your GCP environment and create a Kubernetes Engine cluster running a simple application. The configuration will use your personal account to build out these resources. To setup the default account the configuration will use, run the following command to select the appropriate account:

```console
$ gcloud auth application-default login
```

### Install Java

Follow directions for your platform to [install Java 1.8](https://www.java.com/en/download/help/download_options.xml). For many platforms, you can use a package manager to install it.

### Install Bazel

After installing Java, follow directions for your platform to [install Bazel](https://docs.bazel.build/versions/master/install.html). For many platforms, you can use a package manager to install it.

NOTE: Currently a known issue with Bazel 0.21.0. This demo has been tested with Bazel 0.20.0 and 0.19.2.

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

If no errors are displayed, then after a few minutes you should see your Kubernetes Engine cluster in the [GCP Console](https://console.cloud.google.com/kubernetes).

### Build & deploy with Bazel

To use Bazel to deploy our applications run:
```console
make create
```

This will:
1. Build the Java & Angular apps from source.
2. Containerize the Java & Angular apps, registering them in GCR.
3. Deploy each of the containers to our Kubernetes cluster, creating a service for each of them to expose their endpoints.

The output of `make create` will show you what IP address to visit in your browser to see the Angular SPA. You can also visit your GCP console to see the deployments running on your cluster under "Workloads" and their services with their IP addresses under "Services."

#### K8s Rules

The [Bazel Kubernetes Rules](https://github.com/bazelbuild/rules_k8s) are responsible for the bulk of the deployment work here, and it's worth taking a moment to discuss what's going on under the hood.

When a K8s deployment is declared in the BUILD.bazel file, an image attribute is provided, which is a hash of a name and optional tag, with a bazel target to build the image. The K8s Bazel rule runs the Bazel target to build the image, then uses a python script to upload the image to the declared `image_chroot` with the image name and tag.

We are also required to provide a deployment template file for our K8s deployment, which declares a container image that matches the string declared in the `k8s_deploy` function. The actual image in the `deployment.yaml` is replaced by K8s to point to the exact image uploaded, with its sha256, avoiding any issues that can come up from using "latest" in a `deployment.yaml` file.

## Validation

Run `make validate` to verify that our application was deployed successfully.

## Teardown

When you are finished with this example, and you are ready to clean up the resources that were created so that you avoid accruing charges, you can run the following make command to remove all resources on GCP and any configurations that were added/updated to your local environment:

```
make teardown
```

## Troubleshooting

** The install script fails with a `Permission denied` when running Terraform.**
The credentials that Terraform is using do not provide the
necessary permissions to create resources in the selected projects. Ensure
that the account listed in `gcloud config list` has necessary permissions to
create resources. If it does, regenerate the application default credentials
using `gcloud auth application-default login`.

** A Yarn package failed to install**
Sometimes a Yarn package will fail to install, but will succeed upon re-trying the `make create` command.

## Relevant Material
* [Terraform Google Cloud Provider](https://www.terraform.io/docs/providers/google/index.html)
* [Bazel](http://bazel.build)
* [Bazel Docker rules](https://github.com/bazelbuild/rules_docker)
* [Bazel k8s rules](https://github.com/bazelbuild/rules_k8s)

**This is not an officially supported Google product**
