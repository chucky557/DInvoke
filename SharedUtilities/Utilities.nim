#[
https://learn.microsoft.com/en-us/windows/win32/api/wintrust/ns-wintrust-wintrust_file_info

]#
import winim, winim/lean

proc FileHasValidSignature(FilePath: string): bool =
    # chek file passed and parse the trust info
    var 
        fileProperties: WINTRUST_FILE_INFO
        trustData: WINTRUST_DATA

    fileProperties.cbStruct = sizeof(WINTRUST_FILE_INFO).DWORD
    fileProperties.pcwszFilePath = newWideCString(FilePath)

    trustData.cbStruct = sizeof(WINTRUST_DATA).DWORD
    trustData.dwUIChoice = WTD_UI_NONE
    trustData.fdwRevocationChecks = WTD_REVOKE_WHOLECHAIN 
    # still unsure if WTD_REVOKE_NONE or WTD_CACHE_ONLY_URL_RETRIEVAL for the revocation checks
    trustData.dwUnionChoice = WTD_CHOICE_FILE
    trustData.pFile = addr fileProperties
    trustData.dwStateAction = WTD_STATEACTION_VERIFY
    trustData.dwProvFlags = WTD_REVOCATION_CHECK_CHAIN 
    # not sure whether to use NONE instead of CHAIN

    var actionID = WINTRUST_ACTION_GENERIC_VERIFY_V2
    let status = WinVerifyTrust(NULL, addr actionID, addr trustData)

    return status == ERROR_SUCCESS



