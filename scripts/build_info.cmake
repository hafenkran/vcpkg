set(BUILD_INFO_FILE_PATH ${CURRENT_PACKAGES_DIR}/BUILD_INFO)
file(WRITE  ${BUILD_INFO_FILE_PATH} "CRTLinkage: ${VCPKG_CRT_LINKAGE}\n")
file(APPEND ${BUILD_INFO_FILE_PATH} "LibraryLinkage: ${VCPKG_LIBRARY_LINKAGE}\n")

if (DEFINED VCPKG_POLICY_DLLS_WITHOUT_LIBS)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsWithoutLIBs: ${VCPKG_POLICY_DLLS_WITHOUT_LIBS}\n")
endif()
if (DEFINED VCPKG_POLICY_DLLS_WITHOUT_EXPORTS)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsWithoutExports: ${VCPKG_POLICY_DLLS_WITHOUT_EXPORTS}\n")
endif()
if (DEFINED VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsInStaticLibrary: ${VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY}\n")
endif()
if (DEFINED VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyMismatchedNumberOfBinaries: ${VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES}\n")
endif()
if (DEFINED VCPKG_POLICY_EMPTY_PACKAGE)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyEmptyPackage: ${VCPKG_POLICY_EMPTY_PACKAGE}\n")
endif()
if (DEFINED VCPKG_POLICY_ONLY_RELEASE_CRT)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyOnlyReleaseCRT: ${VCPKG_POLICY_ONLY_RELEASE_CRT}\n")
endif()
if (DEFINED VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyAllowObsoleteMsvcrt: ${VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT}\n")
endif()
if (DEFINED VCPKG_POLICY_EMPTY_INCLUDE_FOLDER)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyEmptyIncludeFolder: ${VCPKG_POLICY_EMPTY_INCLUDE_FOLDER}\n")
endif()
if (DEFINED VCPKG_POLICY_ALLOW_RESTRICTED_HEADERS)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyAllowRestrictedHeaders: ${VCPKG_POLICY_ALLOW_RESTRICTED_HEADERS}\n")
endif()
if (DEFINED VCPKG_POLICY_SKIP_DUMPBIN_CHECKS)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicySkipDumpbinChecks: ${VCPKG_POLICY_SKIP_DUMPBIN_CHECKS}\n")
endif()
if (DEFINED VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicySkipArchitectureCheck: ${VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK}\n")
endif()
if (DEFINED VCPKG_POLICY_CMAKE_HELPER_PORT)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyCmakeHelperPort: ${VCPKG_POLICY_CMAKE_HELPER_PORT}\n")
endif()
if (DEFINED VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK)
    file(APPEND ${BUILD_INFO_FILE_PATH} "PolicySkipAbsolutePathsCheck: ${VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK}\n")
endif()
if (DEFINED VCPKG_HEAD_VERSION)
    file(APPEND ${BUILD_INFO_FILE_PATH} "Version: ${VCPKG_HEAD_VERSION}\n")
endif()
