# Port of SharedData/Native.cs
# Native data structures and constants used by the port.

import system, winim
# C# IntPtr -> Nim pointer
# C# UIntPtr -> Nim uintPtr

type
  UNICODE_STRING* = object
    Length*: uint16
    MaximumLength*: uint16
    Buffer*: pointer

  ANSI_STRING* = object
    Length*: uint16
    MaximumLength*: uint16
    Buffer*: pointer

  PROCESS_BASIC_INFORMATION* = object
    ExitStatus*: pointer
    PebBaseAddress*: pointer
    AffinityMask*: pointer
    BasePriority*: pointer
    UniqueProcessId*: ptr uint
    InheritedFromUniqueProcessId*: int32

  processBasicInformationSize*(info: PROCESS_BASIC_INFORMATION): int = sizeof(info): int

  OBJECT_ATTRIBUTES* = object
    Length*: int32
    RootDirectory*: pointer
    ObjectName*: pointer
    Attributes*: uint32
    SecurityDescriptor*: pointer
    SecurityQualityOfService*: pointer

  IO_STATUS_BLOCK* = object
    Status*: pointer
    Information*: pointer

  CLIENT_ID* = object
    UniqueProcess*: ptr
    UniqueThread*: pointer

  OSVERSIONINFOEX* = object
    OSVersionInfoSize*: uint32
    MajorVersion*: uint32
    MinorVersion*: uint32
    BuildNumber*: uint32
    PlatformId*: uint32
    CSDVersion*: array[0..127, char]
    ServicePackMajor*: uint16
    ServicePackMinor*: uint16
    SuiteMask*: uint16
    ProductType*: uint8
    Reserved*: uint8

  LIST_ENTRY* = object
    Flink*: pointer
    Blink*: pointer

# Enumerations and constants

type
  MEMORYINFOCLASS* = int32

const
  MemoryBasicInformation* = 0
  MemoryWorkingSetList* = 1
  MemorySectionName* = 2
  MemoryBasicVlmInformation* = 3

  PROCESSINFOCLASS* = int32
  ProcessBasicInformation* = 0
  ProcessQuotaLimits* = 1
  ProcessIoCounters* = 2
  ProcessVmCounters* = 3
  ProcessTimes* = 4
  ProcessBasePriority* = 5
  ProcessRaisePriority* = 6
  ProcessDebugPort* = 7
  ProcessExceptionPort* = 8
  ProcessAccessToken* = 9
  ProcessLdtInformation* = 10
  ProcessLdtSize* = 11
  ProcessDefaultHardErrorMode* = 12
  ProcessIoPortHandlers* = 13
  ProcessPooledUsageAndLimits* = 14
  ProcessWorkingSetWatch* = 15
  ProcessUserModeIOPL* = 16
  ProcessEnableAlignmentFaultFixup* = 17
  ProcessPriorityClass* = 18
  ProcessWx86Information* = 19
  ProcessHandleCount* = 20
  ProcessAffinityMask* = 21
  ProcessPriorityBoost* = 22
  ProcessDeviceMap* = 23
  ProcessSessionInformation* = 24
  ProcessForegroundInformation* = 25
  ProcessWow64Information* = 26
  ProcessImageFileName* = 27
  ProcessLUIDDeviceMapsEnabled* = 28
  ProcessBreakOnTermination* = 29
  ProcessDebugObjectHandle* = 30
  ProcessDebugFlags* = 31
  ProcessHandleTracing* = 32
  ProcessIoPriority* = 33
  ProcessExecuteFlags* = 34
  ProcessResourceManagement* = 35
  ProcessCookie* = 36
  ProcessImageInformation* = 37
  ProcessCycleTime* = 38
  ProcessPagePriority* = 39
  ProcessInstrumentationCallback* = 40
  ProcessThreadStackAllocation* = 41
  ProcessWorkingSetWatchEx* = 42
  ProcessImageFileNameWin32* = 43
  ProcessImageFileMapping* = 44
  ProcessAffinityUpdateMode* = 45
  ProcessMemoryAllocationMode* = 46
  ProcessGroupInformation* = 47
  ProcessTokenVirtualizationEnabled* = 48
  ProcessConsoleHostProcess* = 49
  ProcessWindowInformation* = 50
  ProcessHandleInformation* = 51
  ProcessMitigationPolicy* = 52
  ProcessDynamicFunctionTableInformation* = 53
  ProcessHandleCheckingMode* = 54
  ProcessKeepAliveCount* = 55
  ProcessRevokeFileHandles* = 56
  MaxProcessInfoClass* = 57

  CREATE_SUSPENDED* = 0x00000001'u64
  SKIP_THREAD_ATTACH* = 0x00000002'u64
  HIDE_FROM_DEBUGGER* = 0x00000004'u64
  HAS_SECURITY_DESCRIPTOR* = 0x00000010'u64
  ACCESS_CHECK_IN_TARGET* = 0x00000020'u64
  INITIAL_THREAD* = 0x00000080'u64

  NTSTATUS_Success* = 0x00000000'u32
  NTSTATUS_Wait0* = 0x00000000'u32
  NTSTATUS_Wait1* = 0x00000001'u32
  NTSTATUS_Wait2* = 0x00000002'u32
  NTSTATUS_Wait3* = 0x00000003'u32
  NTSTATUS_Wait63* = 0x0000003f'u32
  NTSTATUS_Abandoned* = 0x00000080'u32
  NTSTATUS_AbandonedWait0* = 0x00000080'u32
  NTSTATUS_AbandonedWait1* = 0x00000081'u32
  NTSTATUS_AbandonedWait2* = 0x00000082'u32
  NTSTATUS_AbandonedWait3* = 0x00000083'u32
  NTSTATUS_AbandonedWait63* = 0x000000bf'u32
  NTSTATUS_UserApc* = 0x000000c0'u32
  NTSTATUS_KernelApc* = 0x00000100'u32
  NTSTATUS_Alerted* = 0x00000101'u32
  NTSTATUS_Timeout* = 0x00000102'u32
  NTSTATUS_Pending* = 0x00000103'u32
  NTSTATUS_Reparse* = 0x00000104'u32
  NTSTATUS_MoreEntries* = 0x00000105'u32
  NTSTATUS_NotAllAssigned* = 0x00000106'u32
  NTSTATUS_SomeNotMapped* = 0x00000107'u32
  NTSTATUS_OpLockBreakInProgress* = 0x00000108'u32
  NTSTATUS_VolumeMounted* = 0x00000109'u32
  NTSTATUS_RxActCommitted* = 0x0000010a'u32
  NTSTATUS_NotifyCleanup* = 0x0000010b'u32
  NTSTATUS_NotifyEnumDir* = 0x0000010c'u32
  NTSTATUS_NoQuotasForAccount* = 0x0000010d'u32
  NTSTATUS_PrimaryTransportConnectFailed* = 0x0000010e'u32
  NTSTATUS_PageFaultTransition* = 0x00000110'u32
  NTSTATUS_PageFaultDemandZero* = 0x00000111'u32
  NTSTATUS_PageFaultCopyOnWrite* = 0x00000112'u32
  NTSTATUS_PageFaultGuardPage* = 0x00000113'u32
  NTSTATUS_PageFaultPagingFile* = 0x00000114'u32
  NTSTATUS_CrashDump* = 0x00000116'u32
  NTSTATUS_ReparseObject* = 0x00000118'u32
  NTSTATUS_NothingToTerminate* = 0x00000122'u32
  NTSTATUS_ProcessNotInJob* = 0x00000123'u32
  NTSTATUS_ProcessInJob* = 0x00000124'u32
  NTSTATUS_ProcessCloned* = 0x00000129'u32
  NTSTATUS_FileLockedWithOnlyReaders* = 0x0000012a'u32
  NTSTATUS_FileLockedWithWriters* = 0x0000012b'u32
  NTSTATUS_Informational* = 0x40000000'u32
  NTSTATUS_ObjectNameExists* = 0x40000000'u32
  NTSTATUS_ThreadWasSuspended* = 0x40000001'u32
  NTSTATUS_WorkingSetLimitRange* = 0x40000002'u32
  NTSTATUS_ImageNotAtBase* = 0x40000003'u32
  NTSTATUS_RegistryRecovered* = 0x40000009'u32
  NTSTATUS_Warning* = 0x80000000'u32
  NTSTATUS_GuardPageViolation* = 0x80000001'u32
  NTSTATUS_DatatypeMisalignment* = 0x80000002'u32
  NTSTATUS_Breakpoint* = 0x80000003'u32
  NTSTATUS_SingleStep* = 0x80000004'u32
  NTSTATUS_BufferOverflow* = 0x80000005'u32
  NTSTATUS_NoMoreFiles* = 0x80000006'u32
  NTSTATUS_HandlesClosed* = 0x8000000a'u32
  NTSTATUS_PartialCopy* = 0x8000000d'u32
  NTSTATUS_DeviceBusy* = 0x80000011'u32
  NTSTATUS_InvalidEaName* = 0x80000013'u32
  NTSTATUS_EaListInconsistent* = 0x80000014'u32
  NTSTATUS_NoMoreEntries* = 0x8000001a'u32
  NTSTATUS_LongJump* = 0x80000026'u32
  NTSTATUS_DllMightBeInsecure* = 0x8000002b'u32
  NTSTATUS_Error* = 0xc0000000'u32
  NTSTATUS_Unsuccessful* = 0xc0000001'u32
  NTSTATUS_NotImplemented* = 0xc0000002'u32
  NTSTATUS_InvalidInfoClass* = 0xc0000003'u32
  NTSTATUS_InfoLengthMismatch* = 0xc0000004'u32
  NTSTATUS_AccessViolation* = 0xc0000005'u32
  NTSTATUS_InPageError* = 0xc0000006'u32
  NTSTATUS_PagefileQuota* = 0xc0000007'u32
  NTSTATUS_InvalidHandle* = 0xc0000008'u32
