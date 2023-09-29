load("@toolchains//:fortran_toolchain.bzl", "FortranCompilerInfo")

def _fortran_binary_impl(ctx):
    file = ctx.attrs.file
    extension = ".exe" if host_info().os.is_windows else ""
    out = ctx.actions.declare_output(ctx.attrs.o_name+ extension)

    cmd = cmd_args([ctx.attrs.toolchain[FortranCompilerInfo].compiler_path, "-O3", "-o", out.as_output(), file])

    ctx.actions.run(cmd, category = "compile")

    def compile_with_header_deps(ctx, artifacts, outputs, dep_file_json=dep_file_json, object=object, src=src):
        cmd = cmd_args([compiler, src, flags, inc_flags, "-c", "-o", outputs[object].as_output()])

        # for every header in the list, add a hidden dependency on it to the cmd
        dep_header_list = artifacts[dep_file_json].read_json()
        for header in dep_header_list:
            cmd.hidden(ctx.attrs.inputs[CInputsInfo].hdrs[header])

        ctx.actions.run(cmd, category = "compile", identifier = str(outputs[object]))

    print("test")

    def f(ctx, artifacts, outputs, out=out):
      print(outputs)

    # ctx.actions.dynamic_output([out], f)
    return [DefaultInfo(default_output = out), RunInfo(args = cmd_args([out]))]

fortran_binary = rule(
    impl = _fortran_binary_impl,
    attrs = {
        "file": attrs.source(),
        "toolchain": attrs.toolchain_dep(),
        "o_name": attrs.string(),
    },
)