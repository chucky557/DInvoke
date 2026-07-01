# Port of DynamicInvoke/Generic.cs
# Generic module for dynamically invoking arbitrary API calls from memory or disk.
# Avoids suspicious P/Invoke signatures by loading modules and invoking functions at runtime.

import system, Native
import ../SharedData/[Native, PE, Win32]
import ../ManualMap/[Map, Overload]
# C# original: namespace DInvoke.DynamicInvoke, public class Generic
# Nim translation: Module-level procedures with direct API mapping

## Dynamically invoke an arbitrary function from a DLL.
## Author: The Wover (@TheRealWover)
## Params:
##   DLLName - Name of the DLL
##   FunctionName - Name of the function
##   FunctionDelegateType - Prototype for the function (represented as a type)
##   Parameters - Parameters to pass to function (can be modified if call-by-reference)
## Returns: Result from the function (must be unmarshalled by caller)
proc DynamicAPIInvoke*(
  DLLName: string, 
  FunctionName: string, 
  FunctionDelegateType: pointer, 
  Parameters: var seq[pointer]
): pointer =
  # C# original: IntPtr pFunction = GetLibraryAddress(DLLName, FunctionName);
  let pFunction = GetLibraryAddress(DLLName, FunctionName)
  # C# original: return DynamicFunctionInvoke(pFunction, FunctionDelegateType, ref Parameters);
  return DynamicFunctionInvoke(pFunction, FunctionDelegateType, Parameters)

## Dynamically invoke an arbitrary function from a pointer.
## Useful for manually mapped modules or loading/invoking unmanaged code from memory.
## Author: The Wover (@TheRealWover)
## Params:
##   FunctionPointer - A pointer to the unmanaged function
##   FunctionDelegateType - Prototype for the function
##   Parameters - Parameters to pass (can be modified if call-by-reference)
## Returns: Result from the function (must be unmarshalled by caller)
proc DynamicFunctionInvoke*(
  FunctionPointer: pointer, 
  FunctionDelegateType: pointer, 
  Parameters: var seq[pointer]
): pointer =
  # In C#, this uses Marshal.GetDelegateForFunctionPointer and DynamicInvoke.
  # Nim does not have direct equivalents for runtime delegate creation.
  # This would require unsafe function pointer casting in Nim.
  # TODO: Implement this using Nim's unsafe function pointer mechanisms
  raise newException(NotImplementedError, 
    "DynamicFunctionInvoke requires runtime function pointer casting")

## Resolves LdrLoadDll and uses that function to load a DLL from disk.
## Author: Ruben Boonen (@FuzzySec)
## Params: DLLPath - The path to the DLL on disk (uses LoadLibrary convention)
## Returns: IntPtr base address of loaded module or nil if unsuccessful
proc LoadModuleFromDisk*(DLLPath: string): pointer =
  # C# original: Uses UNICODE_STRING and RtlInitUnicodeString for NT-style loading
  # Nim translation: For now, use loadLibrary as a fallback
  # TODO: Implement UNICODE_STRING and RtlInitUnicodeString when NT wrappers are available
  let hModule = loadLibrary(DLLPath)
  if hModule == nil:
    return nil
  return hModule

## Helper for getting the pointer to a function from a DLL loaded by the process.
## Author: Ruben Boonen (@FuzzySec)
## Params:
##   DLLName - The name of the DLL (e.g. "ntdll.dll" or "C:\Windows\System32\ntdll.dll")
##   FunctionName - Name of the exported procedure
##   CanLoadFromDisk - Optional; if true, try to load from disk if not in loaded module list
## Returns: Pointer to the desired function
proc GetLibraryAddress*(
  DLLName: string, 
  FunctionName: string, 
  CanLoadFromDisk: bool = false
): pointer =
  # C# original: IntPtr hModule = GetLoadedModuleAddress(DLLName);
  var hModule = GetLoadedModuleAddress(DLLName)
  
  # C# original: if (hModule == IntPtr.Zero && CanLoadFromDisk)
  if hModule == nil and CanLoadFromDisk:
    hModule = LoadModuleFromDisk(DLLName)
    if hModule == nil:
      raise newException(OSError, DLLName & ", unable to find the specified file.")
  elif hModule == nil:
    raise newException(OSError, DLLName & ", Dll was not found.")
  
  # C# original: return GetExportAddress(hModule, FunctionName);
  return GetExportAddress(hModule, FunctionName)

## Helper overload for getting function pointer by ordinal.
## Author: Ruben Boonen (@FuzzySec)
## Params:
##   DLLName - The name of the DLL
##   Ordinal - Ordinal of the exported procedure
##   CanLoadFromDisk - Optional; if true, try to load from disk
## Returns: Pointer to the desired function
proc GetLibraryAddress*(
  DLLName: string, 
  Ordinal: int16, 
  CanLoadFromDisk: bool = false
): pointer =
  # C# original: Identical pattern, but uses GetExportAddress with ordinal
  var hModule = GetLoadedModuleAddress(DLLName)
  if hModule == nil and CanLoadFromDisk:
    hModule = LoadModuleFromDisk(DLLName)
    if hModule == nil:
      raise newException(OSError, DLLName & ", unable to find the specified file.")
  elif hModule == nil:
    raise newException(OSError, DLLName & ", Dll was not found.")
  
  return GetExportAddress(hModule, Ordinal)

## Helper overload for getting function pointer by hash.
## Author: Ruben Boonen (@FuzzySec)
## Params:
##   DLLName - The name of the DLL
##   FunctionHash - Hash of the exported procedure
##   Key - 64-bit integer to initialize the keyed hash object
##   CanLoadFromDisk - Optional; if true, try to load from disk
## Returns: Pointer to the desired function
proc GetLibraryAddress*(
  DLLName: string, 
  FunctionHash: string, 
  Key: int64, 
  CanLoadFromDisk: bool = false
): pointer =
  # C# original: Identical pattern, but uses GetExportAddress with hash
  var hModule = GetLoadedModuleAddress(DLLName)
  if hModule == nil and CanLoadFromDisk:
    hModule = LoadModuleFromDisk(DLLName)
    if hModule == nil:
      raise newException(OSError, DLLName & ", unable to find the specified file.")
  elif hModule == nil:
    raise newException(OSError, DLLName & ", Dll was not found.")
  
  return GetExportAddress(hModule, FunctionHash, Key)

## Get the base address of a loaded module from the process's loaded module list.
## This is typically retrieved from the PEB (Process Environment Block).
## Author: Ruben Boonen (@FuzzySec)
## Params: DLLName - The name of the DLL
## Returns: Pointer to the module base, or nil if not found
proc GetLoadedModuleAddress*(DLLName: string): pointer =
  # C# original: Uses GetPebLdrModuleEntry for PEB traversal
  # Nim translation: For now, use loadLibrary as fallback
  # TODO: Implement PEB traversal when NT structures are available
  return loadLibrary(DLLName)

## Get the PEB Ldr module entry for a loaded DLL.
## Author: Ruben Boonen (@FuzzySec)
## Params: DLLName - The name of the DLL
## Returns: Pointer to LDR_DATA_TABLE_ENTRY
proc GetPebLdrModuleEntry*(DLLName: string): pointer =
  # C# original: Traverses PEB -> Ldr -> module list to find module
  # Nim translation: Not yet implemented; requires PEB structure access
  raise newException(NotImplementedError, "GetPebLdrModuleEntry is not yet implemented in Nim port")

## Calculate the hash of an API name using HMAC-MD5.
## Author: Originally from SharpSploit
## Params: 
##   APIName - Name of the API function
##   Key - 64-bit key for hashing
## Returns: Hex string representation of the hash
proc GetAPIHash*(APIName: string, Key: int64): string =
  # C# original: Calculates HMAC-MD5 of APIName using Key
  # Nim translation: TODO - requires MD5/HMAC implementation
  raise newException(NotImplementedError, "GetAPIHash is not yet implemented in Nim port")

## Get the address of an exported function by name.
## Author: Ruben Boonen (@FuzzySec)
## Params:
##   ModuleBase - Base address of the module
##   ExportName - Name of the export
## Returns: Pointer to the function
proc GetExportAddress*(ModuleBase: pointer, ExportName: string): pointer =
  # C# original: Uses PE headers to walk EAT (Export Address Table)
  # Nim translation: Use Nim's dynlib.getProcAddress when possible
  # TODO: Implement manual PE walking for all cases
  raise newException(NotImplementedError, "GetExportAddress by name is not yet implemented in Nim port")

## Get the address of an exported function by ordinal.
## Author: Ruben Boonen (@FuzzySec)
## Params:
##   ModuleBase - Base address of the module
##   Ordinal - Ordinal of the export
## Returns: Pointer to the function
proc GetExportAddress*(ModuleBase: pointer, Ordinal: int16): pointer =
  # C# original: Uses PE headers to walk EAT by ordinal
  # Nim translation: Manual PE parsing required
  # TODO: Implement manual PE walking
  raise newException(NotImplementedError, "GetExportAddress by ordinal is not yet implemented in Nim port")

## Get the address of an exported function by hash.
## Author: Originally from SharpSploit
## Params:
##   ModuleBase - Base address of the module
##   FunctionHash - Hash of the function name
##   Key - 64-bit key for hash validation
## Returns: Pointer to the function
proc GetExportAddress*(ModuleBase: pointer, FunctionHash: string, Key: int64): pointer =
  # C# original: Calculates hash of each export and compares to FunctionHash
  # Nim translation: TODO - requires EAT walking and hash calculation
  raise newException(NotImplementedError, "GetExportAddress by hash is not yet implemented in Nim port")
