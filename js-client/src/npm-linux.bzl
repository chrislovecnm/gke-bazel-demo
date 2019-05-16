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

# TODO this is not working but may help us compile npm on a mac

package_node_modules_cmd = """
    mkdir -p "$@"
    cp -pRL "external/npm/node_modules" "$(@D)"
    """

rebuild_node_modules_cmd = """
    NPM="$$(pwd)/$(location @nodejs//:bin/npm)"
    (
        cd "$(@D)"
        # Remove known-bad dependencies.
        rm -rf node_modules/fsevents
        # Fetch native module binaries for Linux. We're explicitly setting
        # --fallback-to-build=false so that we never build from source.
        # If we build from source on macOS, we will get a macOS binary,
        # which we don't want.
        $$NPM rebuild \
            --update-binary \
            --target_arch=x64 \
            --target_platform=linux \
            --target_libc=glibc \
            --fallback-to-build=false
    ) > "$(@D)/npm.log"
    """

def linux_node_modules(name, visibility=None):
  native.genrule(
      name = "node_modules-rebuilt",
      message = "Packaging node_modules for Linux",
      srcs = [],
      tools = [
        "@nodejs//:bin/npm",
        "@npm//:node_modules",
      ],
      outs = ["node_modules"],

      tags = ["local"],  # run without sandboxing for ~2x speedup on macOS

      cmd = select({
        "@bazel_tools//src/conditions:darwin": (
          package_node_modules_cmd + rebuild_node_modules_cmd
          ),
          "//conditions:default": package_node_modules_cmd,
      }),
    )
