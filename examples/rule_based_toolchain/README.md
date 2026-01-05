# Rule-based toolchains
This example showcases a fully working rule-based toolchain for Linux and Windows.
This also serves as an integration test to ensure rule-based toolchains continue to work
as intended.

The complete toolchain configuration lives [here](https://github.com/bazelbuild/rules_cc/tree/main/examples/rule_based_toolchain/toolchains).

# Trying the example
From this directory, you can run example tests that build using this toolchain
with the following command:
```
$ bazel test //...
```

By default, it will build with `clang`. To use `gcc`, try the following command:

```
$ bazel test --config=gcc //...
```

On Windows, you can select `msvc-cl` or `clang-cl`. For `msvc-cl`, the MSVC
tools must be available on `PATH` (for example, from a Visual Studio Developer
Command Prompt). The `clang-cl` toolchain uses the prebuilt clang archive
referenced in `examples/rule_based_toolchain/MODULE.bazel`.

```
$ bazel test --config=msvc-cl //...
$ bazel test --config=clang-cl //...
```
