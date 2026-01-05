load("//cc/toolchains:feature.bzl", "cc_feature")
load("//cc/toolchains/impl:args_for_compiler.bzl", "cc_args_for_compiler")

package(default_visibility = ["//visibility:public"])

WINDOWS_PREPROCESSOR_DEFINES_ACTIONS = [
    "//cc/toolchains/actions:assemble",
    "//cc/toolchains/actions:preprocess_assemble",
    "//cc/toolchains/actions:c_compile",
    "//cc/toolchains/actions:linkstamp_compile",
    "//cc/toolchains/actions:cpp_compile",
    "//cc/toolchains/actions:cpp_header_parsing",
    "//cc/toolchains/actions:cpp_module_compile",
    "//cc/toolchains/actions:cpp_module_deps_scanning",
    "//cc/toolchains/actions:cpp20_module_compile",
]

cc_feature(
    name = "feature",
    args = [
        ":preprocessor_defines",
        ":preprocessor_defines_windows",
    ],
    overrides = "//cc/toolchains/features/legacy:preprocessor_defines",
)

cc_args_for_compiler(
    name = "preprocessor_defines",
    actions = ["//cc/toolchains/actions:source_compile_actions"],
    exclude_compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["-D{preprocessor_defines}"],
    format = {"preprocessor_defines": "//cc/toolchains/variables:preprocessor_defines"},
    iterate_over = "//cc/toolchains/variables:preprocessor_defines",
)

cc_args_for_compiler(
    name = "preprocessor_defines_windows",
    actions = WINDOWS_PREPROCESSOR_DEFINES_ACTIONS,
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/D{preprocessor_defines}"],
    format = {"preprocessor_defines": "//cc/toolchains/variables:preprocessor_defines"},
    iterate_over = "//cc/toolchains/variables:preprocessor_defines",
)
