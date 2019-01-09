# Developing the Bazel / K8s demo

## Table of Contents
* [Bazel intro](#bazel-intro)
* [Local Dev](#local-dev)
* [Maven to Bazel Java dependencies](#maven-to-bazel-java-dependencies)
* [Testing Containers Locally](#testing-containers-locally)
* [Planter](#planter)
* [Linter](#linter)
* [Helpful scripts](#helpful-scripts)
* [Alpha RBE Support](#alpha-rbe-support)

## Bazel Intro

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
* anything between `//` and `:` are package/directory names
	* Ex: if you want to call a target named `foo` in a `BUILD.bazel` file in the package/directory of `js-client/src/todos`, it'd be this `//js-client/src/todos:foo`

Lastly, the `WORKSPACE` file is a Bazel file at the root directory of your project, responsible for fetching dependencies to run your Bazel commands.

See more at [bazel.build](https://bazel.build).

## Local Dev

If you want to make any changes to the applications & re-deploy to your Kubernetes cluster, you can run them locally first to test your changes.

To run the Angular application, run `yarn serve` within the `js-client` directory. See the `serve` alias in `js-client/package.json` to see that it uses bazel to run a development server on port 5432 -- `bazel run //js-client/src:devserver`.

Note that if you have a global version of `@angular/cli` installed, you may run into errors when the dev server attempts to compile angular templates with your version of `ng`, not the one in the package.json. If this is your case, uninstall `@angular/cli` globally.

To run the Java application locally, run `mvn spring-boot:run` in the `java-spring-boot` directory.

NOTE: Verify your Angular app is using the correct hostname / IP address for the Java API, either your local instance running, or the IP address of the Java Spring Boot service running on your GKE cluster. That hostname is in `js-client/src/todos/todos.service.ts`.

## Maven to Bazel Java Dependencies

When migrating a Java application from being built by Maven to being built by Bazel, you'll need to reconfigure how dependencies are included in the build system. Maven lists your Java dependencies in a `pom.xml` file, pulls in those dependencies at build time, and makes them available for inclusion as libraries to your source code. In Bazel, you'll do the same for each dependency (and its dependencies) by listing it in your BUILD.bazel file when your source code needs it and the Bazel rule [`maven_jar`](https://docs.bazel.build/versions/master/be/workspace.html#maven_jar) in your WORKSPACE. Including an individual Java library for usage in your Java application is pretty straightforward, but listing dozens of dependencies can be very overwhelming. There are tools to help with your Maven to Bazel conversion process and include all of your dependencies.

### Recommended option

The official [recommended option](https://github.com/johnynek/bazel-deps) for Java dependency injection reads a YAML file where you list your dependencies and provides a Bazel rule for including them all in your WORKSPACE. It also has a tool to to convert your `pom.xml` file to a `dependencies.yaml`, however that tool doesn't currently work. [See more in the open issue](https://github.com/johnynek/bazel-deps/issues/223).

### Deprecated option

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

## Linter

You can run the linter simply with `make lint`, however you'll need to install some dependencies first:

* [Flake8](http://flake8.pycqa.org/en/latest/) is used to lint python source files, so you'll need to install it via `python -m pip install flake8 --user`
* [checkstyle](http://checkstyle.sourceforge.net/) is used to reformat & lint Java source files. Download https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.15/checkstyle-8.15-all.jar and update the path (defaults to `~/Downloads`) to the executable in `test/make.sh` on line 84, in the `check_java` function.
* [shellcheck](https://www.shellcheck.net/) is used to check your shell scripts.
* [python3](https://www.python.org/downloads/) is required to run the Google OSS header verification script.

## Helpful Scripts

`scripts/local_vs_remote.sh` will remove the deployed applications, run `make create` locally, remove the apps again, and then run `make create` with RBE enabled. See the README for notes on RBE.

You can also do a `make destroy_apps` to just destroy the apps that have been deployed to your cluster, without tearing down the cluster.

## Alpha RBE Support

**This is a work in progress, and likely to be broken.**

From the official [Bazel Remote Build Execution docs](https://blog.bazel.build/2018/10/05/remote-build-execution.html):

```
By default, Bazel executes builds and tests on your local machine. Remote execution of a Bazel build allows you to distribute build and test actions across multiple machines, such as a datacenter.

Remote execution provides the following benefits:

* Faster build and test execution through scaling of nodes available for parallel actions
* A consistent execution environment for a development team
* Reuse of build outputs across a development team
```

Google Cloud Platform has [RBE support in alpha](https://blog.bazel.build/2018/10/05/remote-build-execution.html). If you'd like to run this demo with GCP RBE support, you will need to do a few things:

1. Fill out [this form](https://docs.google.com/forms/d/e/1FAIpQLScBai-iQ2tn7RcGcsz3Twjr4yDOeHowrb6-3v5qlgS69GcxbA/viewform) to get alpha access.
2. When you're onboarded to the alpha program, you'll be asked to give project ids to the team so they can whitelist your project as able to use RBE.
3. You may want to re-authenticate to ensure your alpha access is configured locally with `gcloud auth application-default login`.
3. Run the `make create` step of this demo with an RBE flag, like this: `RBE=true make create`.

Troubleshooting:
* If you want to verify your alpha access and RBE authentication are correct, the RBE documentation has instructions for building an example application. Follow those instructions to verify your setup.
* If you're getting errors when running `gcloud` alpha commands in `scripts/create.sh`, make sure to update all gcloud components: `gcloud components update`.
* If you're not the owner of the project you're using, you'll likely need to add some IAM roles to your account to enable the RBE API & create worker pools.
