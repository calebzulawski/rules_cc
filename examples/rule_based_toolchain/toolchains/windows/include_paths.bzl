"""Repository rule to capture Windows system include paths from the environment."""

def _windows_include_paths_impl(repository_ctx):
    include_env = repository_ctx.os.environ.get("INCLUDE", "")
    paths = []
    if include_env:
        for raw in include_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            # Normalize to forward slashes for simpler Starlark escaping and validation.
            paths.append(raw.replace("\\", "/"))

    arch = repository_ctx.os.environ.get("PROCESSOR_ARCHITECTURE", "").lower()
    if arch in ["amd64", "x86_64"]:
        resource_label = repository_ctx.attr.clang_resource_header_x86_64
    elif arch in ["arm64", "aarch64"]:
        resource_label = repository_ctx.attr.clang_resource_header_aarch64
    else:
        resource_label = None

    if resource_label:
        resource_path = repository_ctx.path(Label(resource_label))
        if resource_path.exists:
            paths.append(str(resource_path.dirname).replace("\\", "/"))

    # De-duplicate while preserving order.
    seen = {}
    unique_paths = []
    for path in paths:
        if path in seen:
            continue
        seen[path] = True
        unique_paths.append(path)

    repository_ctx.file(
        "include_paths.bzl",
        "INCLUDE_PATHS = {}\n".format(repr(unique_paths)),
    )
    repository_ctx.file(
        "BUILD.bazel",
        "exports_files([\"include_paths.bzl\"])\n",
    )

windows_include_paths = repository_rule(
    implementation = _windows_include_paths_impl,
    attrs = {
        "clang_resource_header_x86_64": attr.string(),
        "clang_resource_header_aarch64": attr.string(),
    },
    environ = [
        "INCLUDE",
        "PROCESSOR_ARCHITECTURE",
    ],
)
