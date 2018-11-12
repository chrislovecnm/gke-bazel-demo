# The WORKSPACE file tells Bazel that this directory is a "workspace", which is like a project root.
# The content of this file specifies all the external dependencies Bazel needs to perform a build.

####################################
# ESModule imports (and TypeScript imports) can be absolute starting with the workspace name.
# The name of the workspace should match the npm package where we publish, so that these
# imports also make sense when referencing the published package.
workspace(name = "angular_bazel_example")

# The Bazel buildtools repo contains tools like the BUILD file formatter, buildifier
# This commit matches the version of buildifier in angular/ngcontainer
# If you change this, also check if it matches the version in the angular/ngcontainer
# version in /.circleci/config.yml
BAZEL_BUILDTOOLS_VERSION = "49a6c199e3fbf5d94534b2771868677d3f9c6de9"

http_archive(
    name = "com_github_bazelbuild_buildtools",
    url = "https://github.com/bazelbuild/buildtools/archive/%s.zip" % BAZEL_BUILDTOOLS_VERSION,
    strip_prefix = "buildtools-%s" % BAZEL_BUILDTOOLS_VERSION,
    sha256 = "edf39af5fc257521e4af4c40829fffe8fba6d0ebff9f4dd69a6f8f1223ae047b",
)

# The @angular repo contains rule for building Angular applications
http_archive(
    name = "angular",
    url = "https://github.com/angular/angular/archive/7.0.2.zip",
    strip_prefix = "angular-7.0.2",
)

# The @rxjs repo contains targets for building rxjs with bazel
http_archive(
    name = "rxjs",
    url = "https://registry.yarnpkg.com/rxjs/-/rxjs-6.3.3.tgz",
    strip_prefix = "package/src",
    sha256 = "72b0b4e517f43358f554c125e40e39f67688cd2738a8998b4a266981ed32f403",
)

# Angular material
# TODO(gmagolan): update to next tagged https://github.com/angular/material2
http_archive(
    name = "angular_material",
    url = "https://github.com/angular/material2/archive/150c964c320c8573b6c02eb0a7024bb2919a22c2.zip",
    strip_prefix = "material2-150c964c320c8573b6c02eb0a7024bb2919a22c2",
)
# Rules for compiling sass
http_archive(
    name = "io_bazel_rules_sass",
    url = "https://github.com/bazelbuild/rules_sass/archive/1.14.1.zip",
    strip_prefix = "rules_sass-1.14.1",
)

# This local_repository rule is needed to prevent `bazel build ...` from
# drilling down into the @rxjs workspace BUILD files in node_modules/rxjs/src.
# In the future this will no longer be needed.
local_repository(
    name = "ignore_node_modules_rxjs",
    path = "node_modules/rxjs/src",
)

####################################
# Load and install our dependencies downloaded above.

load("@angular//packages/bazel:package.bzl", "rules_angular_dependencies")

rules_angular_dependencies()

load("@build_bazel_rules_nodejs//:defs.bzl", "check_bazel_version", "node_repositories", "yarn_install")

# The minimum bazel version to use with this example repo is 0.17.1
check_bazel_version("0.17.1")
node_repositories(
    node_version = "10.9.0",
    yarn_version = "1.9.2",
)

yarn_install(
    name = "npm",
    package_json = "//js-client:package.json",
    yarn_lock = "//js-client:yarn.lock",
    data = ["//js-client:postinstall.tsconfig.json"],
)

load("@io_bazel_rules_go//go:def.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()
go_register_toolchains()

load("@io_bazel_rules_webtesting//web:repositories.bzl", "browser_repositories", "web_test_repositories")

web_test_repositories()
browser_repositories(
    chromium = True,
    firefox = True,
)

load("@build_bazel_rules_typescript//:defs.bzl", "ts_setup_workspace", "check_rules_typescript_version")

ts_setup_workspace()

load("@io_bazel_rules_sass//sass:sass_repositories.bzl", "sass_repositories")

sass_repositories()

load("@angular//:index.bzl", "ng_setup_workspace")

ng_setup_workspace()

load("@angular_material//:index.bzl", "angular_material_setup_workspace")

angular_material_setup_workspace()

################3

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "35c585261362a96b1fe777a7c4c41252b22fd404f24483e1c48b15d7eb2b55a5",
    strip_prefix = "rules_docker-4282829a554058401f7ff63004c8870c8d35e29c",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/4282829a554058401f7ff63004c8870c8d35e29c.tar.gz"],
)

node_repositories(package_json = ["//js-client:package.json"])
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories", "npm_install")
npm_install(
    name = "angular_bazel_example_prod_deps",
    package_json = "//js-client:package.prodserver.json",
)

load(
    "@io_bazel_rules_docker//nodejs:image.bzl",
    _nodejs_image_repos = "repositories",
)

_nodejs_image_repos()

load(
    "@io_bazel_rules_docker//docker:docker.bzl",
    "docker_repositories",
)

docker_repositories()

git_repository(
    name = "io_bazel_rules_k8s",
    commit = "62ae7911ef60f91ed32fdd48a6b837287a626a80",
    remote = "https://github.com/bazelbuild/rules_k8s.git",
)

load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories", "k8s_defaults")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")


k8s_repositories()

k8s_defaults(
    name = "k8s_object",
)

k8s_defaults(
    name = "k8s_deploy",
    kind = "deployment",
    namespace = "default",
)

k8s_defaults(
    name = "k8s_service",
    kind = "service",
    namespace = "default",
)

