######## Package ########
version = "0.1.0"
author = "Ryan Cobb (ported by z0ro)"
description = "Nim port of DInvoke - a dynamic invoke library of unmanaged code in windows"
license = "BSD-3-Clause"
srcDir = "."
bin = @[]

######## Dependencies ########
requires "nim >= 2.0.0"
requires "nimcrypto >= 0.6.0"
#requires "winim >= 3.9.0"

######## Doesn't need compilation as it will just be called and used. No need for shared libraries or such
######## HAPPY HACKING, :)