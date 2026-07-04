import system

const
    # access 
    GENERIC_READ* =  0X80000000
    GENERIC_WRITE* = 0X400000
    GENERIC_EXECUTE* = 0x20000000
    GENERIC_ALL* = 0X10000000

    #section access
    SECTION_QUERY* = 0x0001
    SECTION_MAP_WRITE* = 0x0002
    SECTION_MAP_READ* = 0x0004
    SECTION_MAP_EXECUTE* = 0x0008
    SECTION_EXTEND_SIZE* = 0x0010
    SECTION_ALL_ACCESS* = 0x001F

    # process all access
    PROCESS_ALL_ACCESS* = 0x1F0FFF


type
    # WINIM TYPES: Base types
    BYTE* = int32
    WORD* = uint32
    DWORD* = uint32
    LONG* = int32
    ULONG* = uint32
    ULONGLONG* = uint64
    LONGLONG* = int64

    # pointer-size 
    UINT_PTR* = uint
    INT_PTR* = int
    SIZE_T* = uint

    # Handles
    HANDLE* = pointer
    PHANDLE* = ptr HANDLE
    PVOID* = pointer
    LPVOID* = pointer

    ACCESS_MASK* = ULONG 
    SECURITY_INFORMATION* = ULONG  
    
    UNICODE_STRING* = object
        Length*: uint16
        MaximumLength*: uint16
        Buffer*: pointer

    ANSI_STRING* = object
        Length*: uint16
        MaximumLength*: uint16
        Buffer*: pointer

    PROCESS_BASIC_INFORMATION* {.packed.} = object
        ExitStatus*: pointer
        PebBaseAddress*: pointer
        AffinityMask*: pointer
        BasePriority*: pointer
        UniqueProcessId*: ptr uint
        InheritedFromUniqueProcessId*: int32

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
        UniqueProcess*: pointer
        UniqueThread*: pointer

    OSVERSIONINFOEX* {.packed.}= object
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

    MEMORYINFOCLASS* = enum
        MemoryBasicInformation
        MemoryWorkingSetList
        MemorySectionName
        MemoryBasicVlmInformation

    ## PROCESSINFOCLASS
    PROCESSINFOCLASS* {.pure.}= enum #had to use pure to remove ProcessBasicInfo name clash
        ProcessBasicInformation 
        ProcessQuotaLimits 
        ProcessIoCounters 
        ProcessVmCounters 
        ProcessTimes 
        ProcessBasePriority 
        ProcessRaisePriority 
        ProcessDebugPort 
        ProcessExceptionPort 
        ProcessAccessToken 
        ProcessLdtInformation 
        ProcessLdtSize 
        ProcessDefaultHardErrorMode 
        ProcessIoPortHandlers 
        ProcessPooledUsageAndLimits 
        ProcessWorkingSetWatch 
        ProcessUserModeIOPL 
        ProcessEnableAlignmentFaultFixup 
        ProcessPriorityClass
        ProcessWx86Information
        ProcessHandleCount 
        ProcessAffinityMask 
        ProcessPriorityBoost
        ProcessDeviceMap 
        ProcessSessionInformation 
        ProcessForegroundInformation 
        ProcessWow64Information 
        ProcessImageFileName 
        ProcessLUIDDeviceMapsEnabled 
        ProcessBreakOnTermination 
        ProcessDebugObjectHandle 
        ProcessDebugFlags 
        ProcessHandleTracing 
        ProcessIoPriority 
        ProcessExecuteFlags 
        ProcessResourceManagement 
        ProcessCookie 
        ProcessImageInformation 
        ProcessCycleTime 
        ProcessPagePriority 
        ProcessInstrumentationCallback 
        ProcessThreadStackAllocation 
        ProcessWorkingSetWatchEx 
        ProcessImageFileNameWin32 
        ProcessImageFileMapping 
        ProcessAffinityUpdateMode 
        ProcessMemoryAllocationMode 
        ProcessGroupInformation = 47
        ProcessTokenVirtualizationEnabled 
        ProcessConsoleHostProcess 
        ProcessWindowInformation 
        ProcessHandleInformation 
        ProcessMitigationPolicy 
        ProcessDynamicFunctionTableInformation 
        ProcessHandleCheckingMode 
        ProcessKeepAliveCount 
        ProcessRevokeFileHandles 
        MaxProcessInfoClass 

    ## NT_CREATION_FLAGS is an undocumented enum
    NT_CREATION_FLAGS* = enum
        CREATE_SUSPENDED = 0x00000001'u64
        SKIP_THREAD_ATTACH = 0x00000002'u64
        HIDE_FROM_DEBUGGER = 0x00000004'u64
        HAS_SECURITY_DESCRIPTOR = 0x00000010'u64
        ACCESS_CHECK_IN_TARGET = 0x00000020'u64
        INITIAL_THREAD = 0x00000080'u64

    # NTSTATUS
    # NTSTATUS* = int32
    NTSTATUS* = enum
        # success
        #NTSTATUS_Success = 0x00000000'u32
        NTSTATUS_Wait0 = 0x00000000'u32
        NTSTATUS_Wait1 = 0x00000001'u32
        NTSTATUS_Wait2 = 0x00000002'u32
        NTSTATUS_Wait3 = 0x00000003'u32
        NTSTATUS_Wait63 = 0x0000003f'u32

        #NTSTATUS_Abandoned = 0x00000080'u32
        NTSTATUS_AbandonedWait0 = 0x00000080'u32
        NTSTATUS_AbandonedWait1 = 0x00000081'u32
        NTSTATUS_AbandonedWait2 = 0x00000082'u32
        NTSTATUS_AbandonedWait3 = 0x00000083'u32
        NTSTATUS_AbandonedWait63 = 0x000000bf'u32
        NTSTATUS_UserApc = 0x000000c0'u32
        NTSTATUS_KernelApc = 0x00000100'u32
        NTSTATUS_Alerted = 0x00000101'u32
        NTSTATUS_Timeout = 0x00000102'u32
        NTSTATUS_Pending = 0x00000103'u32
        NTSTATUS_Reparse = 0x00000104'u32
        NTSTATUS_MoreEntries = 0x00000105'u32
        NTSTATUS_NotAllAssigned = 0x00000106'u32
        NTSTATUS_SomeNotMapped = 0x00000107'u32
        NTSTATUS_OpLockBreakInProgress = 0x00000108'u32
        NTSTATUS_VolumeMounted = 0x00000109'u32
        NTSTATUS_RxActCommitted = 0x0000010a'u32
        NTSTATUS_NotifyCleanup = 0x0000010b'u32
        NTSTATUS_NotifyEnumDir = 0x0000010c'u32
        NTSTATUS_NoQuotasForAccount = 0x0000010d'u32
        NTSTATUS_PrimaryTransportConnectFailed = 0x0000010e'u32
        NTSTATUS_PageFaultTransition = 0x00000110'u32
        NTSTATUS_PageFaultDemandZero = 0x00000111'u32
        NTSTATUS_PageFaultCopyOnWrite = 0x00000112'u32
        NTSTATUS_PageFaultGuardPage = 0x00000113'u32
        NTSTATUS_PageFaultPagingFile = 0x00000114'u32
        NTSTATUS_CrashDump = 0x00000116'u32
        NTSTATUS_ReparseObject = 0x00000118'u32
        NTSTATUS_NothingToTerminate = 0x00000122'u32
        NTSTATUS_ProcessNotInJob = 0x00000123'u32
        NTSTATUS_ProcessInJob = 0x00000124'u32
        NTSTATUS_ProcessCloned = 0x00000129'u32
        NTSTATUS_FileLockedWithOnlyReaders = 0x0000012a'u32
        NTSTATUS_FileLockedWithWriters = 0x0000012b'u32
        # informational
        #NTSTATUS_Informational = 0x40000000'u32
        NTSTATUS_ObjectNameExists = 0x40000000'u32
        NTSTATUS_ThreadWasSuspended = 0x40000001'u32
        NTSTATUS_WorkingSetLimitRange = 0x40000002'u32
        NTSTATUS_ImageNotAtBase = 0x40000003'u32
        NTSTATUS_RegistryRecovered = 0x40000009'u32
        # warnings
        NTSTATUS_Warning = 0x80000000'u32
        NTSTATUS_GuardPageViolation = 0x80000001'u32
        NTSTATUS_DatatypeMisalignment = 0x80000002'u32
        NTSTATUS_Breakpoint = 0x80000003'u32
        NTSTATUS_SingleStep = 0x80000004'u32
        NTSTATUS_BufferOverflow = 0x80000005'u32
        NTSTATUS_NoMoreFiles = 0x80000006'u32
        NTSTATUS_HandlesClosed = 0x8000000a'u32
        NTSTATUS_PartialCopy = 0x8000000d'u32
        NTSTATUS_DeviceBusy = 0x80000011'u32
        NTSTATUS_InvalidEaName = 0x80000013'u32
        NTSTATUS_EaListInconsistent = 0x80000014'u32
        NTSTATUS_NoMoreEntries = 0x8000001a'u32
        NTSTATUS_LongJump = 0x80000026'u32
        NTSTATUS_DllMightBeInsecure = 0x8000002b'u32
        # errors
        NTSTATUS_Error = 0xc0000000'u32
        NTSTATUS_Unsuccessful = 0xc0000001'u32
        NTSTATUS_NotImplemented = 0xc0000002'u32
        NTSTATUS_InvalidInfoClass = 0xc0000003'u32
        NTSTATUS_InfoLengthMismatch = 0xc0000004'u32
        NTSTATUS_AccessViolation = 0xc0000005'u32
        NTSTATUS_InPageError = 0xc0000006'u32
        NTSTATUS_PagefileQuota = 0xc0000007'u32
        NTSTATUS_InvalidHandle = 0xc0000008'u32
        BadInitialStack = 0xc0000009'u32
        BadInitialPc = 0xc000000a'u32
        InvalidCid = 0xc000000b'u32
        TimerNotCanceled = 0xc000000c'u32
        InvalidParameter = 0xc000000d'u32
        NoSuchDevice = 0xc000000e'u32
        NoSuchFile = 0xc000000f'u32
        InvalidDeviceRequest = 0xc0000010'u32
        EndOfFile = 0xc0000011'u32
        WrongVolume = 0xc0000012'u32
        NoMediaInDevice = 0xc0000013'u32
        NoMemory = 0xc0000017'u32
        ConflictingAddresses = 0xc0000018'u32
        NotMappedView = 0xc0000019'u32
        UnableToFreeVm = 0xc000001a'u32
        UnableToDeleteSection = 0xc000001b'u32
        IllegalInstruction = 0xc000001d'u32
        AlreadyCommitted = 0xc0000021'u32
        AccessDenied = 0xc0000022'u32
        BufferTooSmall = 0xc0000023'u32
        ObjectTypeMismatch = 0xc0000024'u32
        NonContinuableException = 0xc0000025'u32
        BadStack = 0xc0000028'u32
        NotLocked = 0xc000002a'u32
        NotCommitted = 0xc000002d'u32
        InvalidParameterMix = 0xc0000030'u32
        ObjectNameInvalid = 0xc0000033'u32
        ObjectNameNotFound = 0xc0000034'u32
        ObjectNameCollision = 0xc0000035'u32
        ObjectPathInvalid = 0xc0000039'u32
        ObjectPathNotFound = 0xc000003a'u32
        ObjectPathSyntaxBad = 0xc000003b'u32
        DataOverrun = 0xc000003c'u32
        DataLate = 0xc000003d'u32
        DataError = 0xc000003e'u32
        CrcError = 0xc000003f'u32
        SectionTooBig = 0xc0000040'u32
        PortConnectionRefused = 0xc0000041'u32
        InvalidPortHandle = 0xc0000042'u32
        SharingViolation = 0xc0000043'u32
        QuotaExceeded = 0xc0000044'u32
        InvalidPageProtection = 0xc0000045'u32
        MutantNotOwned = 0xc0000046'u32
        SemaphoreLimitExceeded = 0xc0000047'u32
        PortAlreadySet = 0xc0000048'u32
        SectionNotImage = 0xc0000049'u32
        SuspendCountExceeded = 0xc000004a'u32
        ThreadIsTerminating = 0xc000004b'u32
        BadWorkingSetLimit = 0xc000004c'u32
        IncompatibleFileMap = 0xc000004d'u32
        SectionProtection = 0xc000004e'u32
        EasNotSupported = 0xc000004f'u32
        EaTooLarge = 0xc0000050'u32
        NonExistentEaEntry = 0xc0000051'u32
        NoEasOnFile = 0xc0000052'u32
        EaCorruptError = 0xc0000053'u32
        FileLockConflict = 0xc0000054'u32
        LockNotGranted = 0xc0000055'u32
        DeletePending = 0xc0000056'u32
        CtlFileNotSupported = 0xc0000057'u32
        UnknownRevision = 0xc0000058'u32
        RevisionMismatch = 0xc0000059'u32
        InvalidOwner = 0xc000005a'u32
        InvalidPrimaryGroup = 0xc000005b'u32
        NoImpersonationToken = 0xc000005c'u32
        CantDisableMandatory = 0xc000005d'u32
        NoLogonServers = 0xc000005e'u32
        NoSuchLogonSession = 0xc000005f'u32
        NoSuchPrivilege = 0xc0000060'u32
        PrivilegeNotHeld = 0xc0000061'u32
        InvalidAccountName = 0xc0000062'u32
        UserExists = 0xc0000063'u32
        NoSuchUser = 0xc0000064'u32
        GroupExists = 0xc0000065'u32
        NoSuchGroup = 0xc0000066'u32
        MemberInGroup = 0xc0000067'u32
        MemberNotInGroup = 0xc0000068'u32
        LastAdmin = 0xc0000069'u32
        WrongPassword = 0xc000006a'u32
        IllFormedPassword = 0xc000006b'u32
        PasswordRestriction = 0xc000006c'u32
        LogonFailure = 0xc000006d'u32
        AccountRestriction = 0xc000006e'u32
        InvalidLogonHours = 0xc000006f'u32
        InvalidWorkstation = 0xc0000070'u32
        PasswordExpired = 0xc0000071'u32
        AccountDisabled = 0xc0000072'u32
        NoneMapped = 0xc0000073'u32
        TooManyLuidsRequested = 0xc0000074'u32
        LuidsExhausted = 0xc0000075'u32
        InvalidSubAuthority = 0xc0000076'u32
        InvalidAcl = 0xc0000077'u32
        InvalidSid = 0xc0000078'u32
        InvalidSecurityDescr = 0xc0000079'u32
        ProcedureNotFound = 0xc000007a'u32
        InvalidImageFormat = 0xc000007b'u32
        NoToken = 0xc000007c'u32
        BadInheritanceAcl = 0xc000007d'u32
        RangeNotLocked = 0xc000007e'u32
        DiskFull = 0xc000007f'u32
        ServerDisabled = 0xc0000080'u32
        ServerNotDisabled = 0xc0000081'u32
        TooManyGuidsRequested = 0xc0000082'u32
        GuidsExhausted = 0xc0000083'u32
        InvalidIdAuthority = 0xc0000084'u32
        AgentsExhausted = 0xc0000085'u32
        InvalidVolumeLabel = 0xc0000086'u32
        SectionNotExtended = 0xc0000087'u32
        NotMappedData = 0xc0000088'u32
        ResourceDataNotFound = 0xc0000089'u32
        ResourceTypeNotFound = 0xc000008a'u32
        ResourceNameNotFound = 0xc000008b'u32
        ArrayBoundsExceeded = 0xc000008c'u32
        FloatDenormalOperand = 0xc000008d'u32
        FloatDivideByZero = 0xc000008e'u32
        FloatInexactResult = 0xc000008f'u32
        FloatInvalidOperation = 0xc0000090'u32
        FloatOverflow = 0xc0000091'u32
        FloatStackCheck = 0xc0000092'u32
        FloatUnderflow = 0xc0000093'u32
        IntegerDivideByZero = 0xc0000094'u32
        IntegerOverflow = 0xc0000095'u32
        PrivilegedInstruction = 0xc0000096'u32
        TooManyPagingFiles = 0xc0000097'u32
        FileInvalid = 0xc0000098'u32
        InsufficientResources = 0xc000009a'u32
        InstanceNotAvailable = 0xc00000ab'u32
        PipeNotAvailable = 0xc00000ac'u32
        InvalidPipeState = 0xc00000ad'u32
        PipeBusy = 0xc00000ae'u32
        IllegalFunction = 0xc00000af'u32
        PipeDisconnected = 0xc00000b0'u32
        PipeClosing = 0xc00000b1'u32
        PipeConnected = 0xc00000b2'u32
        PipeListening = 0xc00000b3'u32
        InvalidReadMode = 0xc00000b4'u32
        IoTimeout = 0xc00000b5'u32
        FileForcedClosed = 0xc00000b6'u32
        ProfilingNotStarted = 0xc00000b7'u32
        ProfilingNotStopped = 0xc00000b8'u32
        NotSameDevice = 0xc00000d4'u32
        FileRenamed = 0xc00000d5'u32
        CantWait = 0xc00000d8'u32
        PipeEmpty = 0xc00000d9'u32
        CantTerminateSelf = 0xc00000db'u32
        InternalError = 0xc00000e5'u32
        InvalidParameter1 = 0xc00000ef'u32
        InvalidParameter2 = 0xc00000f0'u32
        InvalidParameter3 = 0xc00000f1'u32
        InvalidParameter4 = 0xc00000f2'u32
        InvalidParameter5 = 0xc00000f3'u32
        InvalidParameter6 = 0xc00000f4'u32
        InvalidParameter7 = 0xc00000f5'u32
        InvalidParameter8 = 0xc00000f6'u32
        InvalidParameter9 = 0xc00000f7'u32
        InvalidParameter10 = 0xc00000f8'u32
        InvalidParameter11 = 0xc00000f9'u32
        InvalidParameter12 = 0xc00000fa'u32
        ProcessIsTerminating = 0xc000010a'u32
        MappedFileSizeZero = 0xc000011e'u32
        TooManyOpenedFiles = 0xc000011f'u32
        Cancelled = 0xc0000120'u32
        CannotDelete = 0xc0000121'u32
        InvalidComputerName = 0xc0000122'u32
        FileDeleted = 0xc0000123'u32
        SpecialAccount = 0xc0000124'u32
        SpecialGroup = 0xc0000125'u32
        SpecialUser = 0xc0000126'u32
        MembersPrimaryGroup = 0xc0000127'u32
        FileClosed = 0xc0000128'u32
        TooManyThreads = 0xc0000129'u32
        ThreadNotInProcess = 0xc000012a'u32
        TokenAlreadyInUse = 0xc000012b'u32
        PagefileQuotaExceeded = 0xc000012c'u32
        CommitmentLimit = 0xc000012d'u32
        InvalidImageLeFormat = 0xc000012e'u32
        InvalidImageNotMz = 0xc000012f'u32
        InvalidImageProtect = 0xc0000130'u32
        InvalidImageWin16 = 0xc0000131'u32
        LogonServer = 0xc0000132'u32
        DifferenceAtDc = 0xc0000133'u32
        SynchronizationRequired = 0xc0000134'u32
        DllNotFound = 0xc0000135'u32
        IoPrivilegeFailed = 0xc0000137'u32
        OrdinalNotFound = 0xc0000138'u32
        EntryPointNotFound = 0xc0000139'u32
        ControlCExit = 0xc000013a'u32
        InvalidAddress = 0xc0000141'u32
        PortNotSet = 0xc0000353'u32
        DebuggerInactive = 0xc0000354'u32
        CallbackBypass = 0xc0000503'u32
        PortClosed = 0xc0000700'u32
        MessageLost = 0xc0000701'u32
        InvalidMessage = 0xc0000702'u32
        RequestCanceled = 0xc0000703'u32
        RecursiveDispatch = 0xc0000704'u32
        LpcReceiveBufferExpected = 0xc0000705'u32
        LpcInvalidConnectionUsage = 0xc0000706'u32
        LpcRequestsNotAllowed = 0xc0000707'u32
        ResourceInUse = 0xc0000708'u32
        ProcessIsProtected = 0xc0000712'u32
        VolumeDirty = 0xc0000806'u32
        FileCheckedOut = 0xc0000901'u32
        CheckOutRequired = 0xc0000902'u32
        BadFileType = 0xc0000903'u32
        FileTooLarge = 0xc0000904'u32
        FormsAuthRequired = 0xc0000905'u32
        VirusInfected = 0xc0000906'u32
        VirusDeleted = 0xc0000907'u32
        TransactionalConflict = 0xc0190001'u32
        InvalidTransaction = 0xc0190002'u32
        TransactionNotActive = 0xc0190003'u32
        TmInitializationFailed = 0xc0190004'u32
        RmNotActive = 0xc0190005'u32
        RmMetadataCorrupt = 0xc0190006'u32
        TransactionNotJoined = 0xc0190007'u32
        DirectoryNotRm = 0xc0190008'u32
        CouldNotResizeLog = 0xc0190009'u32
        TransactionsUnsupportedRemote = 0xc019000a'u32
        LogResizeInvalidSize = 0xc019000b'u32
        RemoteFileVersionMismatch = 0xc019000c'u32
        CrmProtocolAlreadyExists = 0xc019000f'u32
        TransactionPropagationFailed = 0xc0190010'u32
        CrmProtocolNotFound = 0xc0190011'u32
        TransactionSuperiorExists = 0xc0190012'u32
        TransactionRequestNotValid = 0xc0190013'u32
        TransactionNotRequested = 0xc0190014'u32
        TransactionAlreadyAborted = 0xc0190015'u32
        TransactionAlreadyCommitted = 0xc0190016'u32
        TransactionInvalidMarshallBuffer = 0xc0190017'u32
        CurrentTransactionNotValid = 0xc0190018'u32
        LogGrowthFailed = 0xc0190019'u32
        ObjectNoLongerExists = 0xc0190021'u32
        StreamMiniversionNotFound = 0xc0190022'u32
        StreamMiniversionNotValid = 0xc0190023'u32
        MiniversionInaccessibleFromSpecifiedTransaction = 0xc0190024'u32
        CantOpenMiniversionWithModifyIntent = 0xc0190025'u32
        CantCreateMoreStreamMiniversions = 0xc0190026'u32
        HandleNoLongerValid = 0xc0190028'u32
        NoTxfMetadata = 0xc0190029'u32
        LogCorruptionDetected = 0xc0190030'u32
        CantRecoverWithHandleOpen = 0xc0190031'u32
        RmDisconnected = 0xc0190032'u32
        EnlistmentNotSuperior = 0xc0190033'u32
        RecoveryNotNeeded = 0xc0190034'u32
        RmAlreadyStarted = 0xc0190035'u32
        FileIdentityNotPersistent = 0xc0190036'u32
        CantBreakTransactionalDependency = 0xc0190037'u32
        CantCrossRmBoundary = 0xc0190038'u32
        TxfDirNotEmpty = 0xc0190039'u32
        IndoubtTransactionsExist = 0xc019003a'u32
        TmVolatile = 0xc019003b'u32
        RollbackTimerExpired = 0xc019003c'u32
        TxfAttributeCorrupt = 0xc019003d'u32
        EfsNotAllowedInTransaction = 0xc019003e'u32
        TransactionalOpenNotAllowed = 0xc019003f'u32
        TransactedMappingUnsupportedRemote = 0xc0190040'u32
        TxfMetadataAlreadyPresent = 0xc0190041'u32
        TransactionScopeCallbacksNotSet = 0xc0190042'u32
        TransactionRequiredPromotion = 0xc0190043'u32
        CannotExecuteFileInTransaction = 0xc0190044'u32
        TransactionsNotFrozen = 0xc0190045'u32

        MaximumNtStatus = 0xffffffff'u32


proc processBasicInformationSize*(info: PROCESS_BASIC_INFORMATION): int = sizeof(info)
