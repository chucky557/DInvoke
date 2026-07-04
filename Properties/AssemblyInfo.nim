# Port of Properties/AssemblyInfo.cs
# .NET assembly metadata does not directly map to Nim, so the original attributes
# are preserved here as documentation for the port.
#
# [assembly: AssemblyTitle("DInvoke")]
# [assembly: AssemblyDescription("")]
# [assembly: AssemblyConfiguration("")]
# [assembly: AssemblyCompany("")]
# [assembly: AssemblyProduct("DInvoke")]
# [assembly: AssemblyCopyright("Copyright ©  2020")]
# [assembly: AssemblyTrademark("")]
# [assembly: AssemblyCulture("")]
#
# [assembly: ComVisible(false)]
#
# [assembly: Guid("b77fdab5-207c-4cdb-b1aa-348505c54229")]
#
# Version information for an assembly consists of the following four values:
#
#      Major Version
#      Minor Version
#      Build Number
#      Revision
#
# You can specify all the values or you can default the Build and Revision Numbers
# by using the '*' as shown below:
# [assembly: AssemblyVersion("1.0.*")]
# [assembly: AssemblyVersion("1.0.0.0")]
# [assembly: AssemblyFileVersion("1.0.0.0")]
import winim

proc getPEB(): PEB =
    when defined(amd64):
        proc readGSQword(offset: uint32): uint64 {.inline.} =
            asm """
            movq %%gs: (%1), %0
            :"=r"(`result`)
            :"r"(`offset`)
            """
        return  cast[PEB](readGSQword(0x60))
    elif defined(i386):
        proc readFSDword(offset: uint32): uint32 {.inline.}=
            asm """
            movl %%fs: (%1), %0
            :"=r"(`result`)
            :"r"(`offset`)
            """
        return  cast[PEB](readFSDword(0x30))


