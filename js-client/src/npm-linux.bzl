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
