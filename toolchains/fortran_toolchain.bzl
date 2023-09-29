FortranCompilerInfo = provider(
    doc = "Information about how to invoke the Fortran compiler.",
    fields = ["compiler_path"],
)

def _fortran_local_toolchain_impl(ctx):
    return [DefaultInfo(), FortranCompilerInfo(compiler_path = ctx.attrs.command)]

fortran_local_toolchain = rule(
    impl = _fortran_local_toolchain_impl,
    is_toolchain_rule = True,
    attrs = {
        "command": attrs.string(),
    },
)