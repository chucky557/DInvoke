# Port of Injection/Execution.cs
# Base class and implementations for payload execution strategies.
# Defines how payloads are executed in target processes.

import Payload, Injector
import ../DynamicInvoke/Native

# C# original: using DynamicInvoke = DInvoke.DynamicInvoke;
# Nim: Imports above

# C# original: namespace DInvoke.Injection
# Nim translation: Objects and methods for execution technique dispatch

## Base class for Injection strategies.
## Encapsulates different techniques for executing payloads in processes.
## Author: The Wover (@TheRealWover)
##
## C# original: public abstract class ExecutionTechnique
type ExecutionTechnique* = object of RootObj
  ## Array containing a set of PayloadType objects that are supported.
  supportedPayloads*: seq[string]

## Determines whether this technique supports a particular payload type.
## Author: The Wover (@TheRealWover)
## Params: payload - A payload to check
## Returns: Whether or not the payload is of a supported type for this strategy
proc isSupportedPayloadType*(self: ExecutionTechnique, payload: PayloadType): bool =
  # C# original: Check if payload.GetType() is in supportedPayloads
  # Nim translation: Compare type names
  raise newException(NotImplementedError, "isSupportedPayloadType must be implemented by subclasses")

## Internal method for setting the supported payload types.
## Used in constructors. Must be overridden by subclasses.
## Author: The Wover (@TheRealWover)
proc defineSupportedPayloadTypes*(self: var ExecutionTechnique) =
  # C# original: abstract internal void DefineSupportedPayloadTypes();
  raise newException(NotImplementedError, "defineSupportedPayloadTypes must be implemented by subclasses")

## Inject and execute a payload in the target process using a specific allocation technique.
## Author: The Wover (@TheRealWover)
## Params:
##   payload - The type of payload to execute
##   allocationTechnique - The allocation technique to use
##   process - The target process
## Returns: bool indicating success
proc inject*(
  self: ExecutionTechnique,
  payload: PayloadType,
  allocationTechnique: pointer,  # AllocationTechnique type
  process: pointer  # Process type
): bool =
  # C# original: Complex reflection-based dispatch to find matching Inject overload
  # Nim translation: Simplified for now; subclasses implement actual overloads
  raise newException(NotImplementedError, "inject(payload, technique, process) must be implemented by subclasses")

## Execute a payload in the target process at a specified address.
## Author: The Wover (@TheRealWover)
## Params:
##   payload - The type of payload to execute
##   baseAddress - The base address of the payload
##   process - The target process
## Returns: bool indicating success
proc inject*(
  self: ExecutionTechnique,
  payload: PayloadType,
  baseAddress: pointer,
  process: pointer  # Process type
): bool =
  # C# original: Similar reflection-based dispatch
  # Nim translation: Subclasses implement actual overloads
  raise newException(NotImplementedError, "inject(payload, baseAddress, process) must be implemented by subclasses")

## Execute a payload in the current process using a specific allocation technique.
## Author: The Wover (@TheRealWover)
## Params:
##   payload - The type of payload to execute
##   allocationTechnique - The allocation technique to use
## Returns: bool indicating success
proc inject*(
  self: ExecutionTechnique,
  payload: PayloadType,
  allocationTechnique: pointer  # AllocationTechnique type
): bool =
  # C# original: Reflection-based dispatch for local process injection
  # Nim translation: Subclasses implement actual overloads
  raise newException(NotImplementedError, "inject(payload, technique) must be implemented by subclasses")

## Represents the RemoteThreadCreate execution strategy.
## Executes a payload in a remote process by creating a new thread.
## Allows the user to specify which API call to use for remote thread creation.
## Author: The Wover (@TheRealWover)
##
## C# original: public class RemoteThreadCreate : ExecutionTechnique
type RemoteThreadCreate* = object of ExecutionTechnique
  ## Public options
  suspended*: bool
  api*: RemoteThreadCreateAPI
  ## Handle of the new thread. Only valid after the thread has been created.
  threadHandle*: pointer

## Enumeration of available remote thread creation APIs
## Author: The Wover (@TheRealWover)
type RemoteThreadCreateAPI* = enum
  NtCreateThreadEx = 0
  # NtCreateThread = 1,  # Not implemented
  RtlCreateUserThread = 2
  CreateRemoteThread = 3

## Create a new RemoteThreadCreate instance with default options.
## Author: The Wover (@TheRealWover)
proc newRemoteThreadCreate*(): RemoteThreadCreate =
  var technique = RemoteThreadCreate(
    suspended: false,
    api: RemoteThreadCreateAPI.NtCreateThreadEx,
    threadHandle: nil
  )
  return technique

## Create a new RemoteThreadCreate instance with specified options.
## Author: The Wover (@TheRealWover)
## Params:
##   susp - Whether to create thread in suspended state
##   varAPI - Which API to use for thread creation
proc newRemoteThreadCreate*(susp: bool = false, varAPI: RemoteThreadCreateAPI = RemoteThreadCreateAPI.NtCreateThreadEx): RemoteThreadCreate =
  var technique = RemoteThreadCreate(
    suspended: susp,
    api: varAPI,
    threadHandle: nil
  )
  return technique

## Determines whether this technique supports a particular payload type.
## Author: The Wover (@TheRealWover)
## Params: payload - Payload that will be executed
## Returns: Whether payload is supported
proc isSupportedPayloadType*(self: RemoteThreadCreate, payload: PayloadType): bool =
  # C# original: return supportedPayloads.Contains(payload.GetType());
  # Only PICPayload is supported
  return payload of PICPayload

## Internal method for setting the supported payload types.
## Update when new types of payloads are added.
## Author: The Wover (@TheRealWover)
proc defineSupportedPayloadTypes*(self: var RemoteThreadCreate) =
  # C# original: supportedPayloads = new Type[] { typeof(PICPayload) };
  self.supportedPayloads = @["PICPayload"]

## Inject and execute a PIC payload in the remote process by creating a thread.
## Author: The Wover (@TheRealWover)
## Params:
##   payload - The shellcode payload to execute
##   baseAddress - The address of the shellcode in the target process
##   process - The target process to inject into
## Returns: bool indicating success
proc injectPIC*(
  self: var RemoteThreadCreate,
  payload: PICPayload,
  baseAddress: pointer,
  process: pointer  # Process type
): bool =
  # C# original: Create thread at specified address using selected API
  # Nim translation: TODO - implement actual thread creation
  # Pattern: Use self.api to dispatch to correct API
  raise newException(NotImplementedError, "PIC injection is not yet fully implemented")
