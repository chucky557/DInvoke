# Port of SharedData/PE.cs
# Minimal PE structure definitions required by the manual mapping code.

import system

# Data structures are expressed as Nim objects for interop.

type
  IMAGE_DATA_DIRECTORY* = object
    VirtualAddress*: uint32
    Size*: uint32

  IMAGE_DOS_HEADER* = object
    e_magic*: uint16
    e_cblp*: uint16
    e_cp*: uint16
    e_crlc*: uint16
    e_cparhdr*: uint16
    e_minalloc*: uint16
    e_maxalloc*: uint16
    e_ss*: uint16
    e_sp*: uint16
    e_csum*: uint16
    e_ip*: uint16
    e_cs*: uint16
    e_lfarlc*: uint16
    e_ovno*: uint16
    e_res_0*: uint16
    e_res_1*: uint16
    e_res_2*: uint16
    e_res_3*: uint16
    e_oemid*: uint16
    e_oeminfo*: uint16
    e_res2_0*: uint16
    e_res2_1*: uint16
    e_res2_2*: uint16
    e_res2_3*: uint16
    e_res2_4*: uint16
    e_res2_5*: uint16
    e_res2_6*: uint16
    e_res2_7*: uint16
    e_res2_8*: uint16
    e_res2_9*: uint16
    e_lfanew*: uint32

  IMAGE_OPTIONAL_HEADER32* = object
    Magic*: uint16
    MajorLinkerVersion*: uint8
    MinorLinkerVersion*: uint8
    SizeOfCode*: uint32
    SizeOfInitializedData*: uint32
    SizeOfUninitializedData*: uint32
    AddressOfEntryPoint*: uint32
    BaseOfCode*: uint32
    BaseOfData*: uint32
    ImageBase*: uint32
    SectionAlignment*: uint32
    FileAlignment*: uint32
    MajorOperatingSystemVersion*: uint16
    MinorOperatingSystemVersion*: uint16
    MajorImageVersion*: uint16
    MinorImageVersion*: uint16
    MajorSubsystemVersion*: uint16
    MinorSubsystemVersion*: uint16
    Win32VersionValue*: uint32
    SizeOfImage*: uint32
    SizeOfHeaders*: uint32
    CheckSum*: uint32
    Subsystem*: uint16
    DllCharacteristics*: uint16
    SizeOfStackReserve*: uint32
    SizeOfStackCommit*: uint32
    SizeOfHeapReserve*: uint32
    SizeOfHeapCommit*: uint32
    LoaderFlags*: uint32
    NumberOfRvaAndSizes*: uint32
    ExportTable*: IMAGE_DATA_DIRECTORY
    ImportTable*: IMAGE_DATA_DIRECTORY
    ResourceTable*: IMAGE_DATA_DIRECTORY
    ExceptionTable*: IMAGE_DATA_DIRECTORY
    CertificateTable*: IMAGE_DATA_DIRECTORY
    BaseRelocationTable*: IMAGE_DATA_DIRECTORY
    Debug*: IMAGE_DATA_DIRECTORY
    Architecture*: IMAGE_DATA_DIRECTORY
    GlobalPtr*: IMAGE_DATA_DIRECTORY
    TLSTable*: IMAGE_DATA_DIRECTORY
    LoadConfigTable*: IMAGE_DATA_DIRECTORY
    BoundImport*: IMAGE_DATA_DIRECTORY
    IAT*: IMAGE_DATA_DIRECTORY
    DelayImportDescriptor*: IMAGE_DATA_DIRECTORY
    CLRRuntimeHeader*: IMAGE_DATA_DIRECTORY
    Reserved*: IMAGE_DATA_DIRECTORY

  IMAGE_OPTIONAL_HEADER64* = object
    Magic*: uint16
    MajorLinkerVersion*: uint8
    MinorLinkerVersion*: uint8
    SizeOfCode*: uint32
    SizeOfInitializedData*: uint32
    SizeOfUninitializedData*: uint32
    AddressOfEntryPoint*: uint32
    BaseOfCode*: uint32
    ImageBase*: uint64
    SectionAlignment*: uint32
    FileAlignment*: uint32
    MajorOperatingSystemVersion*: uint16
    MinorOperatingSystemVersion*: uint16
    MajorImageVersion*: uint16
    MinorImageVersion*: uint16
    MajorSubsystemVersion*: uint16
    MinorSubsystemVersion*: uint16
    Win32VersionValue*: uint32
    SizeOfImage*: uint32
    SizeOfHeaders*: uint32
    CheckSum*: uint32
    Subsystem*: uint16
    DllCharacteristics*: uint16
    SizeOfStackReserve*: uint64
    SizeOfStackCommit*: uint64
    SizeOfHeapReserve*: uint64
    SizeOfHeapCommit*: uint64
    LoaderFlags*: uint32
    NumberOfRvaAndSizes*: uint32
    ExportTable*: IMAGE_DATA_DIRECTORY
    ImportTable*: IMAGE_DATA_DIRECTORY
    ResourceTable*: IMAGE_DATA_DIRECTORY
    ExceptionTable*: IMAGE_DATA_DIRECTORY
    CertificateTable*: IMAGE_DATA_DIRECTORY
    BaseRelocationTable*: IMAGE_DATA_DIRECTORY
    Debug*: IMAGE_DATA_DIRECTORY
    Architecture*: IMAGE_DATA_DIRECTORY
    GlobalPtr*: IMAGE_DATA_DIRECTORY
    TLSTable*: IMAGE_DATA_DIRECTORY
    LoadConfigTable*: IMAGE_DATA_DIRECTORY
    BoundImport*: IMAGE_DATA_DIRECTORY
    IAT*: IMAGE_DATA_DIRECTORY
    DelayImportDescriptor*: IMAGE_DATA_DIRECTORY
    CLRRuntimeHeader*: IMAGE_DATA_DIRECTORY
    Reserved*: IMAGE_DATA_DIRECTORY

  IMAGE_FILE_HEADER* = object
    Machine*: uint16
    NumberOfSections*: uint16
    TimeDateStamp*: uint32
    PointerToSymbolTable*: uint32
    NumberOfSymbols*: uint32
    SizeOfOptionalHeader*: uint16
    Characteristics*: uint16

  IMAGE_SECTION_HEADER* = object
    Name*: array[0..7, char]
    VirtualSize*: uint32
    VirtualAddress*: uint32
    SizeOfRawData*: uint32
    PointerToRawData*: uint32
    PointerToRelocations*: uint32
    PointerToLinenumbers*: uint32
    NumberOfRelocations*: uint16
    NumberOfLinenumbers*: uint16
    Characteristics*: uint32

  IMAGE_EXPORT_DIRECTORY* = object
    Characteristics*: uint32
    TimeDateStamp*: uint32
    MajorVersion*: uint16
    MinorVersion*: uint16
    Name*: uint32
    Base*: uint32
    NumberOfFunctions*: uint32
    NumberOfNames*: uint32
    AddressOfFunctions*: uint32
    AddressOfNames*: uint32
    AddressOfNameOrdinals*: uint32

  IMAGE_BASE_RELOCATION* = object
    VirtualAdress*: uint32
    SizeOfBlock*: uint32

  IMAGE_THUNK_DATA32* = object
    ForwarderString*: uint32

  IMAGE_THUNK_DATA64* = object
    ForwarderString*: uint64

  LDR_DATA_TABLE_ENTRY* = object
    InLoadOrderLinks*: LIST_ENTRY
    DllBase*: pointer
    FullDllName*: UNICODE_STRING

  PE_META_DATA* = object
    Is32Bit*: bool
    OptHeader32*: IMAGE_OPTIONAL_HEADER32
    OptHeader64*: IMAGE_OPTIONAL_HEADER64

  PE_MANUAL_MAP* = object
    PEINFO*: PE_META_DATA
    ModuleBase*: pointer
    DecoyModule*: string
