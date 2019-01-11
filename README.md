# Building & Deploying with Bazel on Kubernetes Engine

## Table of Contents
<!--ts-->
<!-- TODO -->
<!--te-->

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

##@ Bazel Intro

If this is your first exposure to the Bazel build system, here's a very quick introduction. Bazel is an open-source version of Google's internal build system, Blaze. Bazel is organized into "packages" and "targets".

A Bazel package is a filesystem directory that contains a `BUILD.bazel` file. For example, `js-client` contains a BUILD.bazel file. A package can contain other packages.

A target is a pointer to a Bazel rule. A `BUILD.bazel` file contains rules, which are actions that Bazel runs. A rule is most commonly used to build source code, but Bazel rules can be written to do just about anything. Targets can also depend on other targets, so that when you tell Bazel to run a target, it will run any dependent targets first.

Here's a quick example of a couple rules in a sample `BUILD.bazel`:

```
java_library(
	name = "first_target",
	...
)

java_library(
	name = "second_target",
	deps = [:first_target],
	...
)
```

Running `bazel run //:second_target` will not only run the rule `java_library` to create the `second_target` Java library, but it will first run the `first_target` target first, which uses `java_library` to create its own target.

A couple notes about syntax:
* `//` is the root package
* `:` is used to denote a target
* `@` is a reference to a remote repository of targets (ex: a rule of `@angular:foo` references the `foo` target in the `angular` remote repository, not our local package)
* anything between `//` and `:` are package/directory names
	* Ex: if you want to call a target named `foo` in a `BUILD.bazel` file in the package/directory of `js-client/src/todos`, it'd be this `//js-client/src/todos:foo`

Lastly, the `WORKSPACE` file is a Bazel file at the root directory of your project, responsible for fetching dependencies to run your Bazel commands.

For more information about bazel visit there website here [bazel.build](https://bazel.build).

## Prerequisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

### Cloud Project

You'll need access to a Google Cloud Project with billing enabled. See [Creating and Managing Projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project. To make cleanup easier it's recommended to create a new project.

[Signup for a free Google Cloud account](https://cloud.google.com/).

### Run Demo in a Google Cloud Shell

Click the button below to run the demo in a [Google Cloud Shell][10].

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?git_repo=https%3A%2F%2Fgithub.com%2FGoogleCloudPlatform%2Fgke-bazel-demo&page=editor&tutorial=README.md)

All the tools for the demo are installed. When using Cloud Shell execute the following
command in order to setup gcloud cli. When executing this command please setup your region
and zone.

```console
gcloud init
```

### Supported Operating Systems

This project will run on macOS, Linux, or in a [Google Cloud Shell][10].

### Tools

The following tools are required. If you are using Google Cloud Shell all of these
tools are installed for you already.

1. [Google Cloud SDK version >= 204.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)
2. [gcloud cli](https://cloud.google.com/sdk/gcloud/)
3. [kubectl matching the latest GKE version](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
4. [terraform](https://www.terraform.io/intro/getting-started/install.html) are also available online.
5. [Java 1.8](https://www.java.com/en/download/help/download_options.xml). For many platforms, you can use a package manager to install it.
6. [Bazel](https://docs.bazel.build/versions/master/install.html). For many platforms, you can use a package manager to install it.

More recent versions of all the tools may function, please feel free to file an
issue if you encounter problems with newer versions.

NOTE: Currently a known issue with Bazel 0.21.0. This demo has been tested with Bazel 0.20.0 and 0.19.2.

### Configure Authentication

The Terraform configuration will execute against your GCP environment and create a Kubernetes Engine cluster running a simple application. The configuration will use your personal account to build out these resources. To setup the default account the configuration will use, run the following command to select the appropriate account:

```console
$ gcloud auth application-default login
```
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

<!-- TODO walk the user through what actually was done

For example we built a container x and deployed it with this deployment. Either show the
user with kubectl or in the gcp console.
-->

## Validation

Run `make validate` to verify that our application was deployed successfully.

<!-- TODO what does this actually do -->

## Teardown

When you are finished with this example, and you are ready to clean up the resources that were created so that you avoid accruing charges, you can run the following make command to remove all resources on GCP and any configurations that were added/updated to your local environment:

```
make teardown
```

## Local Dev

If you want to make any changes to the applications & re-deploy to your Kubernetes cluster, you can run them locally first to test your changes.

To run the Angular application, run `yarn serve` within the `js-client` directory. See the `serve` alias in `js-client/package.json` to see that it uses bazel to run a development server on port 5432 -- `bazel run //js-client/src:devserver`.

Note that if you have a global version of `@angular/cli` installed, you may run into errors when the dev server attempts to compile angular templates with your version of `ng`, not the one in the package.json. If this is your case, uninstall `@angular/cli` globally.

To run the Java application locally, run `mvn spring-boot:run` in the `java-spring-boot` directory.

NOTE: Verify your Angular app is using the correct hostname / IP address for the Java API, either your local instance running, or the IP address of the Java Spring Boot service running on your GKE cluster. That hostname is in `js-client/src/todos/todos.service.ts`.

## Maven to Bazel Java Dependencies

<!-- TODO correctly link the pom.xml file with an href -->

When migrating a Java application from being built by Maven to being built by Bazel, you'll need to reconfigure how dependencies are included in the build system. Maven lists your Java dependencies in a `pom.xml` file, pulls in those dependencies at build time, and makes them available for inclusion as libraries to your source code. In Bazel, you'll do the same for each dependency (and its dependencies) by listing it in your BUILD.bazel file when your source code needs it and the Bazel rule [`maven_jar`](https://docs.bazel.build/versions/master/be/workspace.html#maven_jar) in your WORKSPACE. Including an individual Java library for usage in your Java application is pretty straightforward, but listing dozens of dependencies can be very overwhelming. There are tools to help with your Maven to Bazel conversion process and include all of your dependencies.

### Recommended Option

The official [recommended option](https://github.com/johnynek/bazel-deps) for Java dependency injection reads a YAML file where you list your dependencies and provides a Bazel rule for including them all in your WORKSPACE. It also has a tool to to convert your `pom.xml` file to a `dependencies.yaml`, however that tool doesn't currently work with springboot. [See more in the open issue](https://github.com/johnynek/bazel-deps/issues/223).

### Deprecated Option

[The deprecated option](https://docs.bazel.build/versions/master/generate-workspace.html) for converting your Maven dependencies to Bazel does work however, with a few manual tweaks. The deprecation declaration also isn't listed on the official website, but [listed in the source](https://github.com/bazelbuild/migration-tooling/blob/master/README.md#deprecated). The one issue that could be run into with this tool is being unable to include a single Java dependency as a library, and instead having to list the single dependency, and all of its transitive dependencies, as deps in your BUILD.bazel file when using the `java_library` rule. See `java-spring-boot/BUILD.bazel` for how the Java API application includes its 1 and only dependency (Spring Boot) by listing several transitive dependencies in addition to Spring Boot.

## Testing Containers Locally

If you want to build your image and run it locally to verify that it's working before Bazel deploys it to your GKE cluster, you can follow these steps for the Angular SPA application. Similar steps would be carried out for the Java application.

1. `bazel build //js-client/src:angular_image.tar` builds a tar file of your NodeJS image at `dist/bin/js-client/src/angular_image.tar`
2. `docker load dist/bin/js-client/src/angular_image.tar` loads the image into docker
3. `docker images` will list the images loaded into docker. Take note of the image ID.
4. `docker run <image-id>` will run your image in a container in docker. If the image and application have been configured and built correctly, then the Angular production web server will run.

If you want to jump into the running container in order to poke around and manually run your web server, run `docker run -it --entrypoint=/bin/bash <image-id>`

## Planter

If you're running this demo on OS X, you may run into an issue attempting to build & deploy the Angular client in `js-client`. `make create` will build the image and deploy it to your GKE cluster successfully, however the container may not run successfully on the GKE cluster, so your `angular_js_client` workload may contain errors when you view it in the GCP console.

The reason for this is that the Bazel rule for generating a NodeJS image does not yet properly allow to set a target platform when building dependencies. In other words, you're building the image on OS X, but GKE is trying to run the image on Linux, and that disconnect in NodeJS results in the container crashing. [You can read more about this and track progress on GitHub](https://github.com/bazelbuild/rules_nodejs/issues/396).

[Planter](https://github.com/kubernetes/test-infra/tree/master/planter) is a script which launches a linux container in Docker to run your commands, allowing the build and target platforms to both be linux, which avoids this issue. To use Planter, you will need [Docker](https://www.docker.com/products/docker-desktop) installed first. If you don't have it installed, you'll see an error when running `make create` on OS X.

You'll see `scripts/create.sh` automatically detects if you're on OS X, and runs Planter to help you execute your Bazel build commands in a linux container, so they'll run on the GKE linux container.

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
