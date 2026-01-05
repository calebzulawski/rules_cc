load("//cc/toolchains:args.bzl", "cc_args")
load("//cc/toolchains:feature.bzl", "cc_feature")
load("//cc/toolchains:feature_set.bzl", "cc_feature_set")
load("//cc/toolchains/impl:args_for_compiler.bzl", "cc_args_for_compiler")

cc_feature_set(
    name = "compiler_clang",
    all_of = ["//cc/toolchains/compiler:clang"],
)

cc_feature_set(
    name = "compiler_gcc",
    all_of = ["//cc/toolchains/compiler:gcc"],
)

cc_feature_set(
    name = "compiler_mingw_gcc",
    all_of = ["//cc/toolchains/compiler:mingw-gcc"],
)

cc_feature_set(
    name = "compiler_emscripten",
    all_of = ["//cc/toolchains/compiler:emscripten"],
)


cc_feature(
    name = "feature",
    args = [":flags"],
    requires_any_of = [
        ":compiler_clang",
        ":compiler_gcc",
        ":compiler_mingw_gcc",
        ":compiler_emscripten",
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
