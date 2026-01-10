load("//cc/toolchains:args.bzl", "cc_args")
load("//cc/toolchains:args_list.bzl", "cc_args_list")
load("//cc/toolchains:feature.bzl", "cc_feature")
load("//cc/toolchains:feature_constraint.bzl", "cc_feature_constraint")
load("//cc/toolchains:mutually_exclusive_category.bzl", "cc_mutually_exclusive_category")
load("//cc/toolchains/impl:args_for_compiler.bzl", "cc_args_for_compiler")
load("//cc/toolchains:nested_args.bzl", "cc_nested_args")

package(default_visibility = ["//visibility:public"])

cc_feature(
    name = "def_file_feature",
    feature_name = "def_file",
    args = [":def_file_flags"],
)

cc_args_for_compiler(
    name = "def_file_flags",
    actions = [
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DEF:{def_file_path}",
        "/ignore:4070",
    ],
    format = {"def_file_path": "//cc/toolchains/variables:def_file_path"},
    requires_not_none = "//cc/toolchains/variables:def_file_path",
)

cc_feature(
    name = "parse_showincludes_feature",
    feature_name = "parse_showincludes",
    args = [
        ":parse_showincludes_flags",
        ":parse_showincludes_env",
    ],
)

cc_args_for_compiler(
    name = "parse_showincludes_flags",
    actions = [
        "//cc/toolchains/actions:preprocess_assemble",
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:linkstamp_compile",
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:cpp_module_compile",
        "//cc/toolchains/actions:cpp_header_parsing",
        "//cc/toolchains/actions:cpp_module_deps_scanning",
        "//cc/toolchains/actions:cpp20_module_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/showIncludes"],
)

cc_args_for_compiler(
    name = "parse_showincludes_env",
    actions = [
        "//cc/toolchains/actions:preprocess_assemble",
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:linkstamp_compile",
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:cpp_module_compile",
        "//cc/toolchains/actions:cpp_header_parsing",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    env = {"VSLANG": "1033"},
)

cc_feature(
    name = "default_compile_flags_feature",
    args = [":default_compile_flags"],
    overrides = "//cc/toolchains/features/legacy:default_compile_flags",
)

cc_args_for_compiler(
    name = "default_compile_flags",
    actions = [
        "//cc/toolchains/actions:assemble",
        "//cc/toolchains/actions:preprocess_assemble",
        "//cc/toolchains/actions:linkstamp_compile",
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:cpp_header_parsing",
        "//cc/toolchains/actions:cpp_module_compile",
        "//cc/toolchains/actions:cpp_module_codegen",
        "//cc/toolchains/actions:cpp_module_deps_scanning",
        "//cc/toolchains/actions:cpp20_module_compile",
        "//cc/toolchains/actions:cpp20_module_codegen",
        "//cc/toolchains/actions:lto_backend",
        "//cc/toolchains/actions:clif_match",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DNOMINMAX",
        "/D_CRT_SECURE_NO_DEPRECATE",
        "/D_CRT_SECURE_NO_WARNINGS",
        # TODO: Add BAZEL_WIN32_WINNT override.
        "/D_WIN32_WINNT=0x0601",
        "/bigobj",
        "/Zm500",
        "/EHsc",
        "/wd4351",
        "/wd4291",
        "/wd4250",
        "/wd4996",
    ],
)

cc_feature(
    name = "default_cpp_std_feature",
    feature_name = "default_cpp_std",
    args = [":default_cpp_std_flags"],
)

cc_args_for_compiler(
    name = "default_cpp_std_flags",
    actions = [
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:linkstamp_compile",
        "//cc/toolchains/actions:cpp_header_parsing",
        "//cc/toolchains/actions:cpp_module_compile",
        "//cc/toolchains/actions:cpp_module_codegen",
        "//cc/toolchains/actions:cpp_module_deps_scanning",
        "//cc/toolchains/actions:cpp20_module_compile",
        "//cc/toolchains/actions:cpp20_module_codegen",
        "//cc/toolchains/actions:clif_match",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/std:c++17"],
)

cc_feature(
    name = "cpp20_module_compile_flags_feature",
    feature_name = "cpp20_module_compile_flags",
    args = [
        ":cpp20_module_compile_flags",
        ":cpp20_module_output_flags",
    ],
)

cc_args_for_compiler(
    name = "cpp20_module_compile_flags",
    actions = ["//cc/toolchains/actions:cpp20_module_compile"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/TP",
        "/interface",
    ],
)

cc_args_for_compiler(
    name = "cpp20_module_output_flags",
    actions = ["//cc/toolchains/actions:cpp20_module_compile"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/ifcOutput{cpp_module_output_file}"],
    format = {"cpp_module_output_file": "//cc/toolchains/variables:cpp_module_output_file"},
    requires_not_none = "//cc/toolchains/variables:cpp_module_output_file",
)

cc_feature(
    name = "determinism_feature",
    feature_name = "determinism",
    args = [
        ":determinism_flags",
        ":determinism_flags_clang_cl",
    ],
)

cc_args_for_compiler(
    name = "determinism_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/wd4117",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ],
)

cc_args_for_compiler(
    name = "determinism_flags_clang_cl",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = ["clang-cl"],
    args = ["-Wno-builtin-macro-redefined"],
)

cc_feature(
    name = "nologo_feature",
    feature_name = "nologo",
    args = [":nologo_flags"],
)

cc_args_for_compiler(
    name = "nologo_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:linkstamp_compile",
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:cpp_module_compile",
        "//cc/toolchains/actions:cpp_module_codegen",
        "//cc/toolchains/actions:cpp_header_parsing",
        "//cc/toolchains/actions:cpp_module_deps_scanning",
        "//cc/toolchains/actions:cpp20_module_compile",
        "//cc/toolchains/actions:cpp20_module_codegen",
        "//cc/toolchains/actions:assemble",
        "//cc/toolchains/actions:preprocess_assemble",
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
        "//cc/toolchains/actions:cpp_link_static_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/nologo"],
)

cc_feature(
    name = "remove_unreferenced_code_feature",
    feature_name = "remove_unreferenced_code",
    args = [":remove_unreferenced_code_flags"],
)

cc_args_for_compiler(
    name = "remove_unreferenced_code_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/Zc:inline"],
)

cc_feature(
    name = "ignore_noisy_warnings_feature",
    feature_name = "ignore_noisy_warnings",
    args = [":ignore_noisy_warnings_flags"],
)

cc_args_for_compiler(
    name = "ignore_noisy_warnings_flags",
    actions = ["//cc/toolchains/actions:cpp_link_static_library"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/ignore:4221"],
)

cc_feature(
    name = "symbol_check_feature",
    feature_name = "symbol_check",
    args = [":symbol_check_flags"],
)

cc_args_for_compiler(
    name = "symbol_check_flags",
    actions = ["//cc/toolchains/actions:cpp_link_static_library"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/WX:4006"],
)

cc_feature(
    name = "treat_warnings_as_errors_feature",
    feature_name = "treat_warnings_as_errors",
    args = [":treat_warnings_as_errors_flags"],
)

cc_args_for_compiler(
    name = "treat_warnings_as_errors_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/WX"],
)

cc_feature(
    name = "opt_feature",
    args = [
        ":opt_compile_flags",
    ],
    overrides = "//cc/toolchains/features:opt",
    implies = [
        ":frame_pointer_feature",
        ":smaller_binary_feature",
        ":disable_assertions_feature",
    ],
)

cc_args_for_compiler(
    name = "opt_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/O2",
    ],
)

cc_feature_constraint(
    name = "opt_enabled",
    all_of = ["//cc/toolchains/features:opt"],
)

cc_feature(
    name = "frame_pointer_feature",
    feature_name = "frame_pointer",
    args = [":frame_pointer_flags"],
)

cc_args_for_compiler(
    name = "frame_pointer_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/Oy-"],
    requires_any_of = [":opt_enabled"],
)

cc_feature(
    name = "smaller_binary_feature",
    feature_name = "smaller_binary",
    args = [
        ":smaller_binary_compile_flags",
        ":smaller_binary_link_flags",
    ],
)

cc_args_for_compiler(
    name = "smaller_binary_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/Gy",
        "/Gw",
    ],
    requires_any_of = [":opt_enabled"],
)

cc_args_for_compiler(
    name = "smaller_binary_link_flags",
    actions = [
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/OPT:ICF",
        "/OPT:REF",
    ],
    requires_any_of = [":opt_enabled"],
)

cc_feature(
    name = "disable_assertions_feature",
    feature_name = "disable_assertions",
    args = [":disable_assertions_flags"],
)

cc_args_for_compiler(
    name = "disable_assertions_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/DNDEBUG"],
    requires_any_of = [":opt_enabled"],
)

cc_feature(
    name = "dbg_feature",
    args = [
        ":dbg_compile_flags",
        ":dbg_link_flags",
    ],
    overrides = "//cc/toolchains/features:dbg",
)

cc_nested_args(
    name = "dbg_link_flag_from_variable",
    args = ["{dbg_mode_debug_flag}"],
    format = {"dbg_mode_debug_flag": "//cc/toolchains/variables:dbg_mode_debug_flag"},
    requires_not_none = "//cc/toolchains/variables:dbg_mode_debug_flag",
)

cc_nested_args(
    name = "dbg_link_flag_default",
    args = ["/DEBUG"],
    requires_none = "//cc/toolchains/variables:dbg_mode_debug_flag",
)

cc_nested_args(
    name = "dbg_incremental_no",
    args = ["/INCREMENTAL:NO"],
)

cc_args_for_compiler(
    name = "dbg_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/Od",
        "/Z7",
    ],
)

cc_args_for_compiler(
    name = "dbg_link_flags",
    actions = [
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    nested = [
        ":dbg_link_flag_from_variable",
        ":dbg_link_flag_default",
        ":dbg_incremental_no",
    ],
)

cc_feature(
    name = "fastbuild_feature",
    args = [
        ":fastbuild_compile_flags",
        ":fastbuild_link_flags",
    ],
    overrides = "//cc/toolchains/features:fastbuild",
)

cc_nested_args(
    name = "fastbuild_link_flag_from_variable",
    args = ["{fastbuild_mode_debug_flag}"],
    format = {"fastbuild_mode_debug_flag": "//cc/toolchains/variables:fastbuild_mode_debug_flag"},
    requires_not_none = "//cc/toolchains/variables:fastbuild_mode_debug_flag",
)

cc_nested_args(
    name = "fastbuild_link_flag_default",
    args = ["/DEBUG"],
    requires_none = "//cc/toolchains/variables:fastbuild_mode_debug_flag",
)

cc_nested_args(
    name = "fastbuild_incremental_no",
    args = ["/INCREMENTAL:NO"],
)

cc_args_for_compiler(
    name = "fastbuild_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/Od",
        "/Z7",
    ],
)

cc_args_for_compiler(
    name = "fastbuild_link_flags",
    actions = [
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    nested = [
        ":fastbuild_link_flag_from_variable",
        ":fastbuild_link_flag_default",
        ":fastbuild_incremental_no",
    ],
)

cc_mutually_exclusive_category(
    name = "msvcrt_link_mode",
)

cc_feature(
    name = "dynamic_link_msvcrt_feature",
    feature_name = "dynamic_link_msvcrt",
    args = [":dynamic_link_msvcrt_flags"],
)

cc_feature(
    name = "static_link_msvcrt_feature",
    feature_name = "static_link_msvcrt",
    args = [":static_link_msvcrt_flags"],
)

cc_feature_constraint(
    name = "msvcrt_dbg",
    all_of = ["//cc/toolchains/features:dbg"],
)

cc_feature_constraint(
    name = "msvcrt_no_dbg",
    none_of = ["//cc/toolchains/features:dbg"],
)

cc_feature_constraint(
    name = "msvcrt_no_static_link",
    none_of = [":static_link_msvcrt_feature"],
)

cc_feature_constraint(
    name = "msvcrt_dbg_no_static_link",
    all_of = [":msvcrt_dbg"],
    none_of = [":static_link_msvcrt_feature"],
)

cc_feature_constraint(
    name = "msvcrt_no_dbg_no_static_link",
    all_of = [":msvcrt_no_dbg"],
    none_of = [":static_link_msvcrt_feature"],
)

cc_args_list(
    name = "dynamic_link_msvcrt_flags",
    args = [
        ":dynamic_link_msvcrt_compile_flags",
        ":dynamic_link_msvcrt_compile_flags_dbg",
        ":dynamic_link_msvcrt_link_flags",
        ":dynamic_link_msvcrt_link_flags_dbg",
    ],
)

cc_args_list(
    name = "static_link_msvcrt_flags",
    args = [
        ":static_link_msvcrt_compile_flags",
        ":static_link_msvcrt_compile_flags_dbg",
        ":static_link_msvcrt_link_flags",
        ":static_link_msvcrt_link_flags_dbg",
    ],
)

cc_args_for_compiler(
    name = "dynamic_link_msvcrt_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/MD"],
    requires_any_of = [":msvcrt_no_dbg_no_static_link"],
)

cc_args_for_compiler(
    name = "dynamic_link_msvcrt_compile_flags_dbg",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/MDd"],
    requires_any_of = [":msvcrt_dbg_no_static_link"],
)

cc_args_for_compiler(
    name = "dynamic_link_msvcrt_link_flags",
    actions = ["//cc/toolchains/actions:link_actions"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DEFAULTLIB:msvcrt.lib",
    ],
    requires_any_of = [":msvcrt_no_dbg_no_static_link"],
)

cc_args_for_compiler(
    name = "dynamic_link_msvcrt_link_flags_dbg",
    actions = ["//cc/toolchains/actions:link_actions"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DEFAULTLIB:msvcrtd.lib",
    ],
    requires_any_of = [":msvcrt_dbg_no_static_link"],
)

cc_args_for_compiler(
    name = "static_link_msvcrt_compile_flags",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/MT"],
    requires_any_of = [":msvcrt_no_dbg"],
)

cc_args_for_compiler(
    name = "static_link_msvcrt_compile_flags_dbg",
    actions = [
        "//cc/toolchains/actions:c_compile",
        "//cc/toolchains/actions:cpp_compile",
    ],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = ["/MTd"],
    requires_any_of = [":msvcrt_dbg"],
)

cc_args_for_compiler(
    name = "static_link_msvcrt_link_flags",
    actions = ["//cc/toolchains/actions:link_actions"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DEFAULTLIB:libcmt.lib",
    ],
    requires_any_of = [":msvcrt_no_dbg"],
)

cc_args_for_compiler(
    name = "static_link_msvcrt_link_flags_dbg",
    actions = ["//cc/toolchains/actions:link_actions"],
    compilers = [
        "msvc-cl",
        "clang-cl",
    ],
    args = [
        "/DEFAULTLIB:libcmtd.lib",
    ],
    requires_any_of = [":msvcrt_dbg"],
)

cc_feature(
    name = "windows_machine_flags_feature",
    feature_name = "windows_machine_flags",
    args = [":windows_machine_flags"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "windows_machine_flags",
    actions = [
        "//cc/toolchains/actions:ar_actions",
        "//cc/toolchains/actions:cpp_link_executable",
        "//cc/toolchains/actions:cpp_link_dynamic_library",
        "//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    args = select({
        "//cc/toolchains/impl:windows_x86_64": ["/MACHINE:X64"],
        "//cc/toolchains/impl:windows_x86_32": ["/MACHINE:X86"],
        "//cc/toolchains/impl:windows_aarch64": ["/MACHINE:ARM64"],
        "//conditions:default": [],
    }),
)
