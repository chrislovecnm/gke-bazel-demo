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

################################################################################
# ESModule imports (and TypeScript imports) can be absolute starting with the workspace name.
# The name of the workspace should match the npm package where we publish, so that these
# imports also make sense when referencing the published package.
# The workspace name also maps to your local filesystem when using Bazel.
# So if you run Bazel, change your workspace name, and run again,
# none of your previously cached outputs will be available.
################################################################################
workspace(name = "gke_bazel_example")

################################################################################
# Fetch dependencies for project & Angular client
################################################################################

# "http_archive" is a Bazel rule that loads Bazel repositories &
# makes its targets available for execution.
# It is deprecated however, so we need to manually load it to use it.
# See https://docs.bazel.build/versions/master/be/workspace.html#http_archive
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Load go rules to build kubectl
http_archive(
  name = "io_bazel_rules_go",
  urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.19.1/rules_go-0.19.1.tar.gz"],
  sha256 = "8df59f11fb697743cbb3f26cfb8750395f30471e9eabde0d174c3aebc7a1cd39",
)
load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()
go_register_toolchains()

# This is a specific Bazel toolchain needed for RBE Alpha support.
# See DEVELOPER.md for information on RBE.

http_archive(
  name = "bazel_toolchains",
  urls = [
    "https://github.com/bazelbuild/bazel-toolchains/archive/92dd8a7.tar.gz"
  ],
  strip_prefix = "bazel-toolchains-92dd8a7",
  sha256 = "3a6ffe6dd91ee975f5d5bc5c50b34f58e3881dfac59a7b7aba3323bd8f8571a8",
)

load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")
rbe_autoconfig(name = "rbe_default")


# Skylib provides functions for writing custom Bazel rules.
# We use custom bazel rules in this demo, so we need skylib.
# See https://github.com/bazelbuild/bazel-skylib
# TODO - we need to update this, but scala rules may not be happy
http_archive(
    name = "bazel_skylib",
    sha256 = "9245b0549e88e356cd6a25bf79f97aa19332083890b7ac6481a2affb6ada9752",
    strip_prefix = "bazel-skylib-0.9.0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.9.0.tar.gz"],
    )

# The Bazel buildtools repo contains tools like the BUILD file formatter, buildifier
# This commit matches the version of buildifier in angular/ngcontainer
BAZEL_BUILDTOOLS_VERSION = "db073457c5a56d810e46efc18bb93a4fd7aa7b5e"

# This repo contains developer tools for Bazel.
# See https://github.com/bazelbuild/buildtools
http_archive(
    name = "com_github_bazelbuild_buildtools",
    url = "https://github.com/bazelbuild/buildtools/archive/%s.zip" % BAZEL_BUILDTOOLS_VERSION,
    strip_prefix = "buildtools-%s" % BAZEL_BUILDTOOLS_VERSION,
    )

# Fetch rules_nodejs so we can install our npm dependencies
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "1db950bbd27fb2581866e307c0130983471d4c3cd49c46063a2503ca7b6770a4",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.29.0/rules_nodejs-0.29.0.tar.gz"],
)

# Fetch sass rules for compiling sass files
http_archive(
    name = "io_bazel_rules_sass",
    sha256 = "e5316ee8a09d1cbb732d3938b400836bf94dba91a27476e9e27706c4c0edae1f",
    strip_prefix = "rules_sass-1.17.2",
    url = "https://github.com/bazelbuild/rules_sass/archive/1.17.2.zip",
)


################################################################################
# Load Bazel rules from our dependencies  and run some of their rules to fetch
# further dependencies
################################################################################

# Load the Bazel rules necessary to check Bazel version & others from rules_nodejs repo
load("@build_bazel_rules_nodejs//:defs.bzl", "check_bazel_version", "yarn_install")

# The minimum bazel version to use with this example repo is 0.21.0
check_bazel_version("0.24.0")

# With the yarn_install or npm_install repository rules, Bazel will setup your
# node_modules for you in an external workspace named after the repository rule.
# For example, a yarn_install(name = "npm", ...) will setup an external workspace
# named @npm with the node_modules folder inside of it as well as generating targets
# for each root npm package in node_modules for use as dependencies to other rules.
yarn_install(
    name = "npm",
    package_json = "//js-client:package.json",
    yarn_lock = "//js-client:yarn.lock",
    data = [
       # Needed because this tsconfig file is used in the "postinstall" script.
       "//:angular-metadata.tsconfig.json",
    ],
)

# Install all bazel dependencies of our npm packages
load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")

install_bazel_dependencies()

# Load karma dependencies
load("@npm_bazel_karma//:package.bzl", "rules_karma_dependencies")

rules_karma_dependencies()
# Load karma dependencies
load("@npm_bazel_karma//:package.bzl", "rules_karma_dependencies")

rules_karma_dependencies()

# Load dependencies needed to run Angular e2e tests
# Setup the rules_webtesting toolchain
load("@io_bazel_rules_webtesting//web:repositories.bzl", "web_test_repositories")

web_test_repositories()

# Temporary work-around for https://github.com/angular/angular/issues/28681
# TODO(gregmagolan): go back to @io_bazel_rules_webtesting browser_repositories
load("@npm_bazel_karma//:browser_repositories.bzl", "browser_repositories")

browser_repositories()

# Setup the rules_typescript tooolchain
# Register the Typescript toolchain so it can be used in other Bazel rules
# See https://github.com/bazelbuild/rules_typescript/blob/7b3e927fffdc47fde5a9508629be82820b1cadd4/internal/ts_repositories.bzl#L20
load("@npm_bazel_typescript//:defs.bzl", "ts_setup_workspace")

ts_setup_workspace()

# Setup Sass repositories needed to run Sass rules
# See https://github.com/bazelbuild/rules_sass/blob/master/sass/sass_repositories.bzl#L19
# Setup the rules_sass toolchain
load("@io_bazel_rules_sass//sass:sass_repositories.bzl", "sass_repositories")

sass_repositories()

################################################################################
# Kubernetes dependencies
################################################################################

# Load Bazel rule to pull in git repos, rather than http_archives
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Download the NodeJS Bazel build rules from GitHub
# Fetch rules_nodejs so we can install our npm dependencies
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "1db950bbd27fb2581866e307c0130983471d4c3cd49c46063a2503ca7b6770a4",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.29.0/rules_nodejs-0.29.0.tar.gz"],
)

# Docker rules for Bazel, needed to containerize our applications
# See https://github.com/bazelbuild/rules_docker
# Download the rules_docker repository at release v0.7.0
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "aed1c249d4ec8f703edddf35cbe9dfaca0b5f5ea6e4cd9e83e99f3b0d1136c3d",
    strip_prefix = "rules_docker-0.7.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.7.0.tar.gz"],
)

# Instantiate the "repositories" Bazel rule in rules_docker as "container_repositories"
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

# Download dependencies for container rules
# See https://github.com/bazelbuild/rules_docker/blob/master/container/container.bzl#L79
container_repositories()

# This requires rules_docker to be fully instantiated before
# it is pulled in.
git_repository(
    name = "io_bazel_rules_k8s",
    commit = "a631adc254d11146364664eb66ac67a1e05396ff",
    remote = "https://github.com/bazelbuild/rules_k8s.git",
)

# Load a couple rules we need from the K8s Bazel repo
load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories", "k8s_defaults")
load("@io_bazel_rules_k8s//toolchains/kubectl:kubectl_configure.bzl", "kubectl_configure")

# Build kubectl from source
kubectl_configure(name="k8s_config", build_srcs=True, k8s_commit = "v1.13.5",
  # Run wget https://github.com/kubernetes/kubernetes/archive/v1.13.1.tar.gz
  # to download kubernetes source and run sha256sum on the downloaded archive
  # to get the value of this attribute.
  k8s_sha256 = "6caad3336e6676f26106975ab327548f8ea1d0717a6698f7a407ac811f740250",
  # Open the archive downloaded from https://github.com/kubernetes/kubernetes/archive/
  # This attribute is the name of the top level directory in that archive.
  k8s_prefix = "kubernetes-1.13.5"
)

k8s_repositories()


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

# Instantiate the Bazel rule "repositories" in rules_docker/nodejs as "_nodejs_image_repos"
# See https://github.com/bazelbuild/rules_docker/blob/master/nodejs/image.bzl#L35
load(
    "@io_bazel_rules_docker//nodejs:image.bzl",
    _nodejs_image_repos = "repositories",
    )

# Download dependencies for running NodeJS image Bazel rules
_nodejs_image_repos()

################################################################################
# Java dependencies
################################################################################

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
# TODO update this, but there were errors
git_repository(
    name = "io_bazel_rules_scala",
    remote = "git://github.com/bazelbuild/rules_scala",
    commit = "ca655e5a330cbf1d66ce1d9baa63522752ec6011",
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

# Load the "generated_maven_jars" Bazel rule from our local repo in
# "java-spring-boot/third_party/generate_workspace.bzl"
# This is from https://docs.bazel.build/versions/master/generate-workspace.html
# See DEVELOPER.md for the different method of migrating Maven dependencies to Bazel
load("//java-spring-boot/third_party:generate_workspace.bzl", "generated_maven_jars")

# Loads maven jars listed in java-spring-boot/third_party/generate_workspace.bzl
# to make them available as dependencies in our Java build
generated_maven_jars()
