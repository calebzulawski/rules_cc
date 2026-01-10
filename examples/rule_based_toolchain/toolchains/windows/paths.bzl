"""Repository rule to capture Windows system include/lib paths from the environment."""

def _windows_msvc_paths_impl(repository_ctx):
    include_env = repository_ctx.os.environ.get("INCLUDE", "")
    lib_env = repository_ctx.os.environ.get("LIB", "")
    path_env = repository_ctx.os.environ.get("PATH", "")

    include_paths = []
    if include_env:
        for raw in include_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            include_paths.append(raw.replace("\\", "/"))

    arch = repository_ctx.os.environ.get("PROCESSOR_ARCHITECTURE", "").lower()
    if arch in ["amd64", "x86_64"]:
        target_arch = "x64"
        resource_label = repository_ctx.attr.clang_resource_header_x86_64
        arch_dirs = ["/x64"]
    elif arch in ["x86"]:
        target_arch = "x86"
        resource_label = None
        arch_dirs = ["/x86"]
    elif arch in ["arm64", "aarch64"]:
        target_arch = "arm64"
        resource_label = repository_ctx.attr.clang_resource_header_aarch64
        arch_dirs = ["/arm64"]
    else:
        target_arch = ""
        resource_label = None
        arch_dirs = []

    if resource_label:
        resource_path = repository_ctx.path(Label(resource_label))
        if resource_path.exists:
            include_paths.append(str(resource_path.dirname).replace("\\", "/"))

    def is_arch_path(path):
        if not arch_dirs:
            return True
        for suffix in arch_dirs:
            if path.endswith(suffix):
                return True
        return False

    lib_paths = []
    if lib_env:
        for raw in lib_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            normalized = raw.replace("\\", "/")
            if is_arch_path(normalized):
                lib_paths.append(normalized)

    bin_paths = []
    marker = "/VC/Tools/MSVC/"
    for inc in include_paths:
        if marker in inc and inc.endswith("/include"):
            root = inc[: inc.rfind("/include")]
            if target_arch:
                bin_paths.append(root + "/bin/HostX86/" + target_arch)
                bin_paths.append(root + "/bin/HostX64/" + target_arch)

    msvc_bins = []
    for path in bin_paths:
        if repository_ctx.path(path).exists:
            msvc_bins.append(path.replace("\\", "/"))

    joined = ";".join(msvc_bins + ([path_env] if path_env else []))

    repository_ctx.file(
        "paths.bzl",
        "INCLUDE_PATHS = {}\nLIB_PATHS = {}\nMSVC_PATH = {}\n".format(
            repr(include_paths),
            repr(lib_paths),
            repr(joined),
        ),
    )
    repository_ctx.file(
        "BUILD.bazel",
        "exports_files([\"paths.bzl\"])\n",
    )

windows_msvc_paths = repository_rule(
    implementation = _windows_msvc_paths_impl,
    attrs = {
        "clang_resource_header_x86_64": attr.string(),
        "clang_resource_header_aarch64": attr.string(),
    },
    environ = [
        "INCLUDE",
        "LIB",
        "PATH",
        "PROCESSOR_ARCHITECTURE",
    ],
)
