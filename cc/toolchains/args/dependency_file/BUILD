load("//cc/toolchains:args.bzl", "cc_args")
load("//cc/toolchains:feature.bzl", "cc_feature")
load("//cc/toolchains/impl:args_for_compiler.bzl", "cc_args_for_compiler")

cc_feature(
    name = "feature",
    args = [":flags"],
    requires_any_of = [
        "//cc/toolchains/compiler:clang",
        "//cc/toolchains/compiler:gcc",
        "//cc/toolchains/compiler:mingw-gcc",
        "//cc/toolchains/compiler:emscripten",
    ],
    overrides = "//cc/toolchains/features/legacy:dependency_file",
    visibility = ["//visibility:public"],
)

cc_args_for_compiler(
    name = "flags",
    actions = ["//cc/toolchains/actions:compile_actions"],
    exclude_compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "-MD",
        "-MF",
        "{dependency_file}",
    ],
    format = {"dependency_file": "//cc/toolchains/variables:dependency_file"},
    requires_not_none = "//cc/toolchains/variables:dependency_file",
)
