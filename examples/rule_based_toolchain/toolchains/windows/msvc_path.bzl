"""Repository rule to capture MSVC tool PATH entries for the current host."""

def _windows_msvc_path_impl(repository_ctx):
    include_env = repository_ctx.os.environ.get("INCLUDE", "")
    path_env = repository_ctx.os.environ.get("PATH", "")

    arch = repository_ctx.os.environ.get("PROCESSOR_ARCHITECTURE", "").lower()
    if arch in ["amd64", "x86_64"]:
        target_arch = "x64"
    elif arch in ["x86"]:
        target_arch = "x86"
    elif arch in ["arm64", "aarch64"]:
        target_arch = "arm64"
    else:
        target_arch = ""

    include_paths = []
    if include_env:
        for raw in include_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            include_paths.append(raw.replace("\\", "/"))

    bin_paths = []
    marker = "/VC/Tools/MSVC/"
    for inc in include_paths:
        if marker in inc and inc.endswith("/include"):
            root = inc[: inc.rfind("/include")]
            if target_arch:
                bin_paths.append(root + "/bin/HostX86/" + target_arch)
                bin_paths.append(root + "/bin/HostX64/" + target_arch)

    # De-duplicate while preserving order.
    seen = {}
    unique_bins = []
    for path in bin_paths:
        if path in seen:
            continue
        seen[path] = True
        if repository_ctx.path(path).exists:
            unique_bins.append(path.replace("\\", "/"))

    # Prepend tool paths to the current PATH.
    joined = ";".join(unique_bins + ([path_env] if path_env else []))
    repository_ctx.file(
        "msvc_path.bzl",
        "MSVC_PATH = {}\n".format(repr(joined)),
    )
    repository_ctx.file(
        "BUILD.bazel",
        "exports_files([\"msvc_path.bzl\"])\n",
    )

windows_msvc_path = repository_rule(
    implementation = _windows_msvc_path_impl,
    environ = [
        "INCLUDE",
        "PATH",
        "PROCESSOR_ARCHITECTURE",
    ],
)
