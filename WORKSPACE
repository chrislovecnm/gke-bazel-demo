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

# The WORKSPACE file tells Bazel that this directory is a "workspace", which is like a project root.
# The content of this file specifies all the external dependencies Bazel needs to perform a build.

# IMPORTANT: Read DEVELOPER.md and README.md for more context.

####################################
# ESModule imports (and TypeScript imports) can be absolute starting with the workspace name.
# The name of the workspace should match the npm package where we publish, so that these
# imports also make sense when referencing the published package.
# The workspace name also maps to your local filesystem when using Bazel.
# So if you run Bazel, change your workspace name, and run again,
# none of your previously cached outputs will be available.
workspace(name = "gke_bazel_example")


####################################
# Fetch dependencies for project & Angular client
####################################


# The Bazel buildtools repo contains tools like the BUILD file formatter, buildifier
# This commit matches the version of buildifier in angular/ngcontainer
# If you change this, also check if it matches the version in the angular/ngcontainer
# version in /.circleci/config.yml
BAZEL_BUILDTOOLS_VERSION = "db073457c5a56d810e46efc18bb93a4fd7aa7b5e"

# "http_archive" is a Bazel rule that loads Bazel repositories &
# makes its targets available for execution.
# It is deprecated however, so we need to manually load it to use it.
# See https://docs.bazel.build/versions/master/be/workspace.html#http_archive
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# This is a specific Bazel toolchain needed for RBE Alpha support.
# See DEVELOPER.md for information on RBE.
http_archive(
    name = "bazel_toolchains",
    sha256 = "07a81ee03f5feae354c9f98c884e8e886914856fb2b6a63cba4619ef10aaaf0b",
    strip_prefix = "bazel-toolchains-31b5dc8c4e9c7fd3f5f4d04c6714f2ce87b126c1",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/31b5dc8c4e9c7fd3f5f4d04c6714f2ce87b126c1.tar.gz",
        "https://github.com/bazelbuild/bazel-toolchains/archive/31b5dc8c4e9c7fd3f5f4d04c6714f2ce87b126c1.tar.gz",
        ],
    )

# Skylib provides functions for writing custom Bazel rules.
# We use custom bazel rules in this demo, so we need skylib.
# See https://github.com/bazelbuild/bazel-skylib
http_archive(
    name = "bazel_skylib",
    sha256 = "eb5c57e4c12e68c0c20bc774bfbc60a568e800d025557bc4ea022c6479acc867",
    strip_prefix = "bazel-skylib-0.6.0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.6.0.tar.gz"],
    )

# This repo contains developer tools for Bazel.
# See https://github.com/bazelbuild/buildtools
http_archive(
    name = "com_github_bazelbuild_buildtools",
    url = "https://github.com/bazelbuild/buildtools/archive/%s.zip" % BAZEL_BUILDTOOLS_VERSION,
    strip_prefix = "buildtools-%s" % BAZEL_BUILDTOOLS_VERSION,
    )

# The angular repo contains rules for building Angular applications
# We need the build tools and dependencies from this repo to build our Angular client.
# See https://github.com/angular/angular
http_archive(
    name = "angular",
    url = "https://github.com/angular/angular/archive/7.1.0.zip",
    strip_prefix = "angular-7.1.0",
    sha256 = "18837f6582c2c33adc761f726885f2d14d3b8f57b99f7cfefeb645ca8d9820da",
    )

# We use the RxJS for observables in our data layer in our Angular client.
# The @rxjs repo contains targets for building rxjs with bazel.
# See https://github.com/ReactiveX/rxjs
http_archive(
    name = "rxjs",
    url = "https://registry.yarnpkg.com/rxjs/-/rxjs-6.3.3.tgz",
    strip_prefix = "package/src",
    sha256 = "72b0b4e517f43358f554c125e40e39f67688cd2738a8998b4a266981ed32f403",
    )

# Rules for compiling sass, which we use in our Angular client.
# See https://github.com/bazelbuild/rules_sass
http_archive(
    name = "io_bazel_rules_sass",
    url = "https://github.com/bazelbuild/rules_sass/archive/1.15.1.zip",
    strip_prefix = "rules_sass-1.15.1",
    sha256 = "76ae498b9a96fa029f026f8358ed44b93c934dde4691a798cb3a4137c307b7dc",
    )

# Angular material provides material design components for our Angular client
# Note: material v7.1.1 is compatible with angular v7.1.0 under Bazel
# See https://github.com/angular/material2
http_archive(
    name = "angular_material",
    url = "https://github.com/angular/material2/archive/7.1.1.zip",
    strip_prefix = "material2-7.1.1",
    sha256 = "d3f88aed435f3e1c032736a2f64c61f98790d8c80cb04f4b0b24d1d306317939",
    )

# This local_repository rule is needed to prevent `bazel build ...` from
# drilling down into the @rxjs workspace BUILD files in node_modules/rxjs/src.
# In the future this will no longer be needed.
# See https://github.com/alexeagle/angular-bazel-example/commit/09eab9c6c5ac41c73d0c77ab1b9d84adf522632e
local_repository(
    name = "ignore_node_modules_rxjs",
    path = "js-client/node_modules/rxjs/src",
    )


####################################
# Load Bazel rules from our dependencies
# and run some of their rules to fetch further
# dependencies
####################################

# Fetch & register Angular rules dependencies
# See https://github.com/angular/angular/blob/master/packages/bazel/package.bzl#L11
load("@angular//packages/bazel:package.bzl", "rules_angular_dependencies")
rules_angular_dependencies()

# Fetch & register Typescript rules dependencies
# See https://github.com/bazelbuild/rules_typescript/blob/a1970bac0b866d431b179d299d747ef05bfb42e3/package.bzl#L29
load("@build_bazel_rules_typescript//:package.bzl", "rules_typescript_dependencies")
rules_typescript_dependencies()

# Fetch & register NodeJS rules dependencies
# See https://github.com/bazelbuild/rules_nodejs/blob/master/package.bzl#L51
load("@build_bazel_rules_nodejs//:package.bzl", "rules_nodejs_dependencies")
rules_nodejs_dependencies()

# Load the Bazel rules necessary to check Bazel version & others from rules_nodejs repo
load("@build_bazel_rules_nodejs//:defs.bzl", "check_bazel_version", "node_repositories", "yarn_install")

# The minimum bazel version to use with this example repo is 0.19.0
check_bazel_version("0.19.0")

# This rule installs nodejs, npm, and yarn, but does NOT install
# your npm dependencies into your node_modules folder.
# You must still run the package manager to do this.
# See https://github.com/bazelbuild/rules_nodejs/blob/master/internal/node/node_repositories.bzl#L469
node_repositories(
    node_version = "10.9.0",
    yarn_version = "1.12.1",
    )

# With the yarn_install or npm_install repository rules, Bazel will setup your
# node_modules for you in an external workspace named after the repository rule.
# For example, a yarn_install(name = "npm", ...) will setup an external workspace
# named @npm with the node_modules folder inside of it as well as generating targets
# for each root npm package in node_modules for use as dependencies to other rules.
yarn_install(
    name = "npm",
    package_json = "//js-client:package.json",
    yarn_lock = "//js-client:yarn.lock",
    data = ["//js-client:postinstall.tsconfig.json"],
    )

# Go is used for the Angular client's dev server.
# See https://github.com/alexeagle/angular-bazel-example/commit/c416ce749221cfa671fb5199b32e4eb915532489

# This load statement has Bazel load and evaluate extensions and build files needed for these rules.
# It also instantiates the rules (ex: "go_rules_dependencies" and "go_register_toolchains")
load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")
# Fetches any dependencies Go needs.
go_rules_dependencies()
# Installs the Go toolchains. See https://github.com/bazelbuild/rules_go/blob/master/go/toolchains.rst#go_register_toolchains
go_register_toolchains()

# Load dependencies needed to run Angular e2e tests
load("@io_bazel_rules_webtesting//web:repositories.bzl", "browser_repositories", "web_test_repositories")
web_test_repositories()
browser_repositories(
    chromium = True,
    firefox = True,
    )

# Register the Typescript toolchain so it can be used in other Bazel rules
# See https://github.com/bazelbuild/rules_typescript/blob/7b3e927fffdc47fde5a9508629be82820b1cadd4/internal/ts_repositories.bzl#L20
load("@build_bazel_rules_typescript//:defs.bzl", "ts_setup_workspace", "check_rules_typescript_version")
ts_setup_workspace()

# Setup Sass repositories needed to run Sass rules
# See https://github.com/bazelbuild/rules_sass/blob/master/sass/sass_repositories.bzl#L19
load("@io_bazel_rules_sass//sass:sass_repositories.bzl", "sass_repositories")
sass_repositories()

# Sets up Angular source dependencies to run Angular rules
# See https://github.com/angular/angular/blob/master/tools/ng_setup_workspace.bzl#L12
load("@angular//:index.bzl", "ng_setup_workspace")
ng_setup_workspace()

# Installs Angular Material source dependencies for running Material rules
# See https://github.com/angular/material2/blob/master/tools/angular_material_setup_workspace.bzl#L9
load("@angular_material//:index.bzl", "angular_material_setup_workspace")
angular_material_setup_workspace()

####################################
# Kubernetes dependencies
####################################

# Load Bazel rule to pull in git repos, rather than http_archives
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Download the NodeJS Bazel build rules from GitHub
git_repository(
    name = "build_bazel_rules_nodejs",
    remote = "https://github.com/bazelbuild/rules_nodejs.git",
    tag = "0.16.4",
    )

# Docker rules for Bazel, needed to containerize our applications
# See https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "c0e9d27e6ca307e4ac0122d3dd1df001b9824373fb6fb8627cd2371068e51fef",
    strip_prefix = "rules_docker-0.6.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.6.0.tar.gz"],
    )

# Instantiate the "repositories" Bazel rule in rules_docker as "container_repositories"
load(
    "@io_bazel_rules_docker//container:container.bzl",
    container_repositories = "repositories",
    )

# Download dependencies for container rules
# See https://github.com/bazelbuild/rules_docker/blob/master/container/container.bzl#L79
container_repositories()

# Download the K8s Bazel rules from GitHub
# See https://github.com/bazelbuild/rules_k8s
git_repository(
    name = "io_bazel_rules_k8s",
    commit = "bc9a60a1250af9856c4797aebd79bb08bee370f5",
    remote = "https://github.com/bazelbuild/rules_k8s.git",
    )

# Load a couple rules we need from the K8s Bazel repo
load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories", "k8s_defaults")

# Download the dependencies the K8s Bazel rules need
# See https://github.com/bazelbuild/rules_k8s/blob/master/k8s/k8s.bzl#L22
k8s_repositories()

# Set up some default attributes when the K8s rule "k8s_object" is called later
# This only applies to "k8s_object" called with kind = "deployment"
# This also exposes a Bazel rule called "k8s_deploy"
# which we use in java-spring-boot/BUILD.bazel and js-client/BUILD.bazel.
# See https://github.com/bazelbuild/rules_k8s#k8s_defaults
k8s_defaults(
    name = "k8s_deploy",
    kind = "deployment",
    namespace = "default",
    )

# Set up some default attributes when the K8s rule "k8s_object" is called later
# This only applies to "k8s_object" called with kind = "service"
# See https://github.com/bazelbuild/rules_k8s#k8s_defaults
k8s_defaults(
    name = "k8s_service",
    kind = "service",
    namespace = "default",
    )

# Exposes some Bazel rules to do a `npm install` on the package.json file in "js-client" later
# See https://github.com/bazelbuild/rules_nodejs/blob/master/internal/node/node_repositories.bzl#L469
node_repositories(
    package_json = ["//js-client:package.json"]
    )

# Instantiate the Bazel rule "repositories" in rules_docker/nodejs as "_nodejs_image_repos"
# See https://github.com/bazelbuild/rules_docker/blob/master/nodejs/image.bzl#L35
load(
    "@io_bazel_rules_docker//nodejs:image.bzl",
    _nodejs_image_repos = "repositories",
    )

# Download dependencies for running NodeJS image Bazel rules
_nodejs_image_repos()


####################################
# Java dependencies
####################################

# Instantiate the Bazel rule "repositories" in rules_docker/java as "_java_image_repos"
# See https://github.com/bazelbuild/rules_docker/blob/master/java/image.bzl#L43
load(
    "@io_bazel_rules_docker//java:image.bzl",
    _java_image_repos = "repositories",
    )

# Download dependencies for running Java image Bazel rules
_java_image_repos()

# Download the Bazel Scala rules from Github
# See https://github.com/bazelbuild/rules_scala
git_repository(
    name = "io_bazel_rules_scala",
    remote = "git://github.com/bazelbuild/rules_scala",
    commit = "326b4ce252c36aeff2232e241ff4bfd8d6f6e071",
    )

# Instantiate the "scala_repositories" Bazel rule
# See https://github.com/bazelbuild/rules_scala/blob/master/scala/scala.bzl#L327
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repositories")

# Load dependencies for running Scala Bazel rules
scala_repositories()

# Download a jar from Maven and make it available to be used as a dependency in our Java build
# See https://docs.bazel.build/versions/master/be/workspace.html#maven_jar
maven_jar(
    name="commons_logging_commons_logging",
    artifact="commons-logging:commons-logging:1.2"
    )

# Load the "generated_maven_jars" Bazel rule from our local repo in "java-spring-boot/third_party/generate_workspace.bzl"
# This is from https://docs.bazel.build/versions/master/generate-workspace.html
# See DEVELOPER.md for the different method of migrating Maven dependencies to Bazel
load("//java-spring-boot/third_party:generate_workspace.bzl", "generated_maven_jars")

# Loads maven jars listed in java-spring-boot/third_party/generate_workspace.bzl
# to make them available as dependencies in our Java build
generated_maven_jars()
