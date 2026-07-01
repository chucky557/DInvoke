# Port of SharedData/Win32.cs
# Win32 constants, structures, and enums used by the project.

import system

type
  IMAGE_BASE_RELOCATION* = object
    VirtualAdress*: uint32
    SizeOfBlock*: uint32

  IMAGE_IMPORT_DESCRIPTOR* = object
    OriginalFirstThunk*: uint32
    TimeDateStamp*: uint32
    ForwarderChain*: uint32
    Name*: uint32
    FirstThunk*: uint32

  SYSTEM_INFO* = object
    wProcessorArchitecture*: uint16
    wReserved*: uint16
    dwPageSize*: uint32
    lpMinimumApplicationAddress*: pointer
    lpMaximumApplicationAddress*: pointer
    dwActiveProcessorMask*: ptr uint
    dwNumberOfProcessors*: uint32
    dwProcessorType*: uint32
    dwAllocationGranularity*: uint32
    wProcessorLevel*: uint16
    wProcessorRevision*: uint16

type
  Platform* = enum
    x86
    x64
    IA64
    Unknown

  ProcessAccessFlags* = enum
    PROCESS_ALL_ACCESS = 0x001F0FFF'u32
    PROCESS_CREATE_PROCESS = 0x0080'u32
    PROCESS_CREATE_THREAD = 0x0002'u32
    PROCESS_DUP_HANDLE = 0x0040'u32
    PROCESS_QUERY_INFORMATION = 0x0400'u32
    PROCESS_QUERY_LIMITED_INFORMATION = 0x1000'u32
    PROCESS_SET_INFORMATION = 0x0200'u32
    PROCESS_SET_QUOTA = 0x0100'u32
    PROCESS_SUSPEND_RESUME = 0x0800'u32
    PROCESS_TERMINATE = 0x0001'u32
    PROCESS_VM_OPERATION = 0x0008'u32
    PROCESS_VM_READ = 0x0010'u32
    PROCESS_VM_WRITE = 0x0020'u32
    SYNCHRONIZE = 0x00100000'u32

  FileAccessFlags* = enum
    DELETE = 0x10000'u32
    FILE_READ_DATA = 0x1'u32
    FILE_READ_ATTRIBUTES = 0x80'u32
    FILE_READ_EA = 0x8'u32
    READ_CONTROL = 0x20000'u32
    FILE_WRITE_DATA = 0x2'u32
    FILE_WRITE_ATTRIBUTES = 0x100'u32
    FILE_WRITE_EA = 0x10'u32
    FILE_APPEND_DATA = 0x4'u32
    WRITE_DAC = 0x40000'u32
    WRITE_OWNER = 0x80000'u32
    SYNCHRONIZE = 0x100000'u32
    FILE_EXECUTE = 0x20'u32

  FileShareFlags* = enum
    FILE_SHARE_NONE = 0x0'u32
    FILE_SHARE_READ = 0x1'u32
    FILE_SHARE_WRITE = 0x2'u32
    FILE_SHARE_DELETE = 0x4'u32

  FileOpenFlags* = enum
    FILE_DIRECTORY_FILE = 0x1'u32
    FILE_WRITE_THROUGH = 0x2'u32
    FILE_SEQUENTIAL_ONLY = 0x4'u32
    FILE_NO_INTERMEDIATE_BUFFERING = 0x8'u32
    FILE_SYNCHRONOUS_IO_ALERT = 0x10'u32
    FILE_SYNCHRONOUS_IO_NONALERT = 0x20'u32
    FILE_NON_DIRECTORY_FILE = 0x40'u32
    FILE_CREATE_TREE_CONNECTION = 0x80'u32
    FILE_COMPLETE_IF_OPLOCKED = 0x100'u32
    FILE_NO_EA_KNOWLEDGE = 0x200'u32
    FILE_OPEN_FOR_RECOVERY = 0x400'u32
    FILE_RANDOM_ACCESS = 0x800'u32
    FILE_DELETE_ON_CLOSE = 0x1000'u32
    FILE_OPEN_BY_FILE_ID = 0x2000'u32
    FILE_OPEN_FOR_BACKUP_INTENT = 0x4000'u32
    FILE_NO_COMPRESSION = 0x8000'u32

  StandardRights* = enum
    Delete = 0x00010000'u32
    ReadControl = 0x00020000'u32
    WriteDac = 0x00040000'u32
    WriteOwner = 0x00080000'u32
    Synchronize = 0x00100000'u32
    Required = 0x000f0000'u32
    Write = FileAccessFlags.FILE_WRITE_DATA
    Execute = FileAccessFlags.FILE_EXECUTE
    All = 0x001f0000'u32
    SpecificRightsAll = 0x0000ffff'u32
    AccessSystemSecurity = 0x01000000'u32
    MaximumAllowed = 0x02000000'u32
    GenericRead = 0x80000000'u32
    GenericWrite = 0x40000000'u32
    GenericExecute = 0x20000000'u32
    GenericAll = 0x10000000'u32

  ThreadAccess* = enum
    Terminate = 0x0001'u32
    SuspendResume = 0x0002'u32
    Alert = 0x0004'u32
    GetContext = 0x0008'u32
    SetContext = 0x0010'u32
    SetInformation = 0x0020'u32
    QueryInformation = 0x0040'u32
    SetThreadToken = 0x0080'u32
    Impersonate = 0x0100'u32
    DirectImpersonation = 0x0200'u32
    SetLimitedInformation = 0x0400'u32
    QueryLimitedInformation = 0x0800'u32
    All = 0x001f0fff'u32

  HookProc* = proc (nCode: int32, wParam, lParam: pointer): pointer {.cdecl.}

  LOCALGROUP_USERS_INFO_0* = object
    name*: string

  LOCALGROUP_USERS_INFO_1* = object
    name*: string
    comment*: string

  LOCALGROUP_MEMBERS_INFO_2* = object
    lgrmi2_sid*: pointer
    lgrmi2_sidusage*: int32
    lgrmi2_domainandname*: string

  WKSTA_USER_INFO_1* = object
    wkui1_username*: string
    wkui1_logon_domain*: string
    wkui1_oth_domains*: string
    wkui1_logon_server*: string

  SESSION_INFO_10* = object
    sesi10_cname*: string
    sesi10_username*: string
    sesi10_time*: int32
    sesi10_idle_time*: int32

  SID_NAME_USE* = enum
    SidTypeUser = 1
    SidTypeGroup = 2
    SidTypeDomain = 3
    SidTypeAlias = 4
    SidTypeWellKnownGroup = 5
    SidTypeDeletedAccount = 6
    SidTypeInvalid = 7
    SidTypeUnknown = 8
    SidTypeComputer = 9

  SHARE_INFO_1* = object
    shi1_netname*: string
    shi1_type*: uint32
    shi1_remark*: string

proc newShareInfo1*(netname: string, ty: uint32, remark: string): SHARE_INFO_1 =
  SHARE_INFO_1(shi1_netname: netname, shi1_type: ty, shi1_remark: remark)
