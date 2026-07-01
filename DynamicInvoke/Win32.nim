# Port of DynamicInvoke/Win32.cs
# Contains function prototypes and wrapper functions for dynamically invoking Win32 API calls.
# Provides standard Windows API access through dynamic invocation.

import Native

# C# original: namespace DInvoke.DynamicInvoke, public static class Win32
# Nim translation: Module-level procedures and delegate type definitions

## Uses DynamicInvocation to call the OpenProcess Win32 API.
## Reference: https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess
## Author: The Wover (@TheRealWover)
## Params:
##   dwDesiredAccess - Access rights requested
##   bInheritHandle - Whether to inherit the handle
##   dwProcessId - Process ID to open
## Returns: Handle to the opened process
proc OpenProcess*(
  dwDesiredAccess: uint32, 
  bInheritHandle: bool, 
  dwProcessId: uint32
): pointer =
  # C# original: Craft an array for the arguments
  var funcargs: seq[pointer] = @[
    cast[pointer](dwDesiredAccess), cast[pointer](bInheritHandle), 
    cast[pointer](dwProcessId)
  ]
  
  # C# original: return (IntPtr)Generic.DynamicAPIInvoke(@"kernel32.dll", @"OpenProcess", ...);
  # Nim translation: TODO - implement actual marshalling and invocation
  raise newException(NotImplementedError, "OpenProcess is not yet fully implemented")

## Uses DynamicInvocation to call the CreateRemoteThread Win32 API.
## Params:
##   hProcess - Handle to the target process
##   lpThreadAttributes - Optional thread attributes
##   dwStackSize - Stack size for the new thread
##   lpStartAddress - Address where thread starts executing
##   lpParameter - Parameter passed to thread function
##   dwCreationFlags - Creation flags
##   lpThreadId - Output parameter receiving the thread ID
## Returns: Handle to the new thread
proc CreateRemoteThread*(
  hProcess: pointer,
  lpThreadAttributes: pointer,
  dwStackSize: uint32,
  lpStartAddress: pointer,
  lpParameter: pointer,
  dwCreationFlags: uint32,
  lpThreadId: var pointer
): pointer =
  # C# original: Craft an array for the arguments
  var funcargs: seq[pointer] = @[
    hProcess, lpThreadAttributes, cast[pointer](dwStackSize), lpStartAddress,
    lpParameter, cast[pointer](dwCreationFlags), lpThreadId
  ]
  
  # C# original: return (IntPtr)Generic.DynamicAPIInvoke(...);
  # Note: After invocation, update lpThreadId from funcargs[6]
  # Nim translation: TODO - implement actual invocation with out-parameter handling
  raise newException(NotImplementedError, "CreateRemoteThread is not yet fully implemented")

## Uses DynamicInvocation to call the IsWow64Process Win32 API.
## Reference: https://docs.microsoft.com/en-us/windows/win32/api/wow64apiset/nf-wow64apiset-iswow64process
## Params:
##   hProcess - Handle to the process to check
##   lpSystemInfo - Output parameter receiving WOW64 status
## Returns: true if process is WOW64, false if not (64-bit or 32-bit on 32-bit machine)
proc IsWow64Process*(hProcess: pointer, lpSystemInfo: var bool): bool =
  # C# original: Build the set of parameters to pass in to IsWow64Process
  var funcargs: seq[pointer] = @[hProcess, cast[pointer](lpSystemInfo)]
  
  # C# original: bool retVal = (bool)Generic.DynamicAPIInvoke(...);
  # Nim translation: TODO - implement actual invocation with bool return and out-parameter
  raise newException(NotImplementedError, "IsWow64Process is not yet fully implemented")

# C# original: Nested Delegates class with function pointer definitions
# Nim Translation Note: In Nim, delegate types are represented using proc types
# The following are function signatures that would have been defined as unmanaged delegates in C#

## Prototype for CreateRemoteThread delegate
## C# original: [UnmanagedFunctionPointer(CallingConvention.StdCall)]
## public delegate IntPtr CreateRemoteThread(...)
type CreateRemoteThreadDelegate* = proc(
  hProcess: pointer,
  lpThreadAttributes: pointer,
  dwStackSize: uint32,
  lpStartAddress: pointer,
  lpParameter: pointer,
  dwCreationFlags: uint32,
  lpThreadId: var pointer
): pointer {.stdcall.}

## Prototype for OpenProcess delegate
## C# original: [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
## public delegate IntPtr OpenProcess(...)
type OpenProcessDelegate* = proc(
  dwDesiredAccess: uint32,
  bInheritHandle: bool,
  dwProcessId: uint32
): pointer {.cdecl.}

## Prototype for IsWow64Process delegate
## C# original: [UnmanagedFunctionPointer(CallingConvention.StdCall)]
## public delegate bool IsWow64Process(...)
type IsWow64ProcessDelegate* = proc(
  hProcess: pointer,
  lpSystemInfo: var bool
): bool {.stdcall.}
