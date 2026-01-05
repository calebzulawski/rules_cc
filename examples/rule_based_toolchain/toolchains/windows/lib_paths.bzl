"""Repository rule to capture Windows system library paths from the environment."""

def _windows_lib_paths_impl(repository_ctx):
    lib_env = repository_ctx.os.environ.get("LIB", "")
    include_env = repository_ctx.os.environ.get("INCLUDE", "")
    paths = []

    arch = repository_ctx.os.environ.get("PROCESSOR_ARCHITECTURE", "").lower()
    if arch in ["amd64", "x86_64"]:
        arch_dirs = ["/x64"]
    elif arch in ["x86"]:
        arch_dirs = ["/x86"]
    elif arch in ["arm64", "aarch64"]:
        arch_dirs = ["/arm64"]
    else:
        arch_dirs = []

    def is_arch_path(path):
        if not arch_dirs:
            return True
        for suffix in arch_dirs:
            if path.endswith(suffix):
                return True
        return False

    if lib_env:
        for raw in lib_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            # Normalize to forward slashes for simpler Starlark escaping and validation.
            normalized = raw.replace("\\", "/")
            if is_arch_path(normalized):
                paths.append(normalized)

    def add_if_exists(path):
        if not is_arch_path(path):
            return
        if repository_ctx.path(path).exists:
            paths.append(path.replace("\\", "/"))

    # Derive lib paths from INCLUDE when LIB is missing or incomplete.
    include_paths = []
    if include_env:
        for raw in include_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            include_paths.append(raw.replace("\\", "/"))

    for inc in include_paths:
        # MSVC layout: .../VC/Tools/MSVC/<ver>/include
        marker = "/VC/Tools/MSVC/"
        if marker in inc and inc.endswith("/include"):
            root = inc[: inc.rfind("/include")]
            add_if_exists(root + "/lib/x86")
            add_if_exists(root + "/lib/x64")
            add_if_exists(root + "/lib/arm64")

        # Windows Kits layout: .../Windows Kits/10/include/<ver>/<subdir>
        kits_marker = "/Windows Kits/10/include/"
        if kits_marker in inc:
            base = inc[: inc.rfind("/include/")]
            remainder = inc[inc.rfind("/include/") + len("/include/") :]
            parts = remainder.split("/")
            if len(parts) >= 2:
                version = parts[0]
                for subdir in ["ucrt", "um"]:
                    add_if_exists(base + "/lib/" + version + "/" + subdir + "/x86")
                    add_if_exists(base + "/lib/" + version + "/" + subdir + "/x64")
                    add_if_exists(base + "/lib/" + version + "/" + subdir + "/arm64")

    # De-duplicate while preserving order.
    seen = {}
    unique_paths = []
    for path in paths:
        if path in seen:
            continue
        seen[path] = True
        unique_paths.append(path)

    repository_ctx.file(
        "lib_paths.bzl",
        "LIB_PATHS = {}\n".format(repr(unique_paths)),
    )
    repository_ctx.file(
        "BUILD.bazel",
        "exports_files([\"lib_paths.bzl\"])\n",
    )

windows_lib_paths = repository_rule(
    implementation = _windows_lib_paths_impl,
    environ = [
        "LIB",
        "PROCESSOR_ARCHITECTURE",
    ],
)
