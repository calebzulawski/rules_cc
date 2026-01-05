load("//cc/toolchains:args.bzl", "cc_args")
load("//cc/toolchains:feature.bzl", "cc_feature")

package(default_visibility = ["//visibility:public"])

cc_feature(
    name = "feature",
    args = [":generate_linkmap"],
    feature_name = "generate_linkmap",
)

cc_args(
    name = "generate_linkmap",
    actions = ["//cc/toolchains/actions:link_actions"],
    args = select({
        "//cc/toolchains/impl:windows_x86_64": ["/MAP:{output_execpath}.map"],
        "//cc/toolchains/impl:windows_x86_32": ["/MAP:{output_execpath}.map"],
        "//cc/toolchains/impl:windows_aarch64": ["/MAP:{output_execpath}.map"],
        "@platforms//os:macos": ["-Wl,-map,{output_execpath}.map"],
        "//conditions:default": ["-Wl,-Map={output_execpath}.map"],
    }),
    format = {"output_execpath": "//cc/toolchains/variables:output_execpath"},
    requires_not_none = "//cc/toolchains/variables:output_execpath",
    visibility = ["//visibility:private"],
)
