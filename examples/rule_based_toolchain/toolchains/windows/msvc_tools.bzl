"""Repository rule to expose MSVC tools."""

def _windows_msvc_tools_impl(repository_ctx):
    include_env = repository_ctx.os.environ.get("INCLUDE", "")
    path_env = repository_ctx.os.environ.get("PATH", "")

    arch = repository_ctx.os.environ.get("PROCESSOR_ARCHITECTURE", "").lower()
    if arch in ["amd64", "x86_64"]:
        target_arch = "x64"
        ml_name = "ml64.exe"
        host_order = ["HostX64", "HostX86"]
    elif arch in ["x86"]:
        target_arch = "x86"
        ml_name = "ml.exe"
        host_order = ["HostX86", "HostX64"]
    elif arch in ["arm64", "aarch64"]:
        target_arch = "arm64"
        ml_name = "ml64.exe"
        host_order = ["HostX64", "HostX86"]
    else:
        target_arch = ""
        ml_name = "ml.exe"
        host_order = ["HostX64", "HostX86"]

    include_paths = []
    if include_env:
        for raw in include_env.split(";"):
            raw = raw.strip()
            if not raw:
                continue
            include_paths.append(raw.replace("\\", "/"))

    roots = []
    marker = "/VC/Tools/MSVC/"
    for inc in include_paths:
        if marker in inc and inc.endswith("/include"):
            roots.append(inc[: inc.rfind("/include")])

    bin_dirs = []
    for root in roots:
        if target_arch:
            for host in host_order:
                bin_dirs.append(root + "/bin/" + host + "/" + target_arch)

    bin_dir = None
    for candidate in bin_dirs:
        if repository_ctx.path(candidate).exists:
            bin_dir = candidate
            break

    if not bin_dir:
        fail("Failed to locate MSVC bin directory for arch '{}'.".format(target_arch))

    repository_ctx.symlink(bin_dir, "bin")

    repository_ctx.file(
        "BUILD.bazel",
        "\n".join([
            "package(default_visibility = [\"//visibility:public\"])",
            "",
            "filegroup(",
            "    name = \"cl\",",
            "    srcs = [\"bin/cl.exe\"],",
            ")",
            "filegroup(",
            "    name = \"link\",",
            "    srcs = [\"bin/link.exe\"],",
            ")",
            "filegroup(",
            "    name = \"lib\",",
            "    srcs = [\"bin/lib.exe\"],",
            ")",
            "filegroup(",
            "    name = \"ml\",",
            "    srcs = [\"bin/{}\"],".format(ml_name),
            ")",
            "exports_files([",
            "    \"bin/cl.exe\",",
            "    \"bin/link.exe\",",
            "    \"bin/lib.exe\",",
            "    \"bin/{}\",".format(ml_name),
            "])",
            "",
        ]),
    )

windows_msvc_tools = repository_rule(
    implementation = _windows_msvc_tools_impl,
    environ = [
        "INCLUDE",
        "PATH",
        "PROCESSOR_ARCHITECTURE",
    ],
)
