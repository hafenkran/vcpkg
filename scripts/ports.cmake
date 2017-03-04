cmake_minimum_required(VERSION 3.5)

macro(debug_message)
    if(DEFINED PORT_DEBUG AND PORT_DEBUG)
        message(STATUS "[DEBUG] ${ARGN}")
    endif()
endmacro()

#Detect .vcpkg-root to figure VCPKG_ROOT_DIR
SET(VCPKG_ROOT_DIR_CANDIDATE ${CMAKE_CURRENT_LIST_DIR})
while(IS_DIRECTORY ${VCPKG_ROOT_DIR_CANDIDATE} AND NOT EXISTS "${VCPKG_ROOT_DIR_CANDIDATE}/.vcpkg-root")
    get_filename_component(VCPKG_ROOT_DIR_TEMP ${VCPKG_ROOT_DIR_CANDIDATE} DIRECTORY)
    if (VCPKG_ROOT_DIR_TEMP STREQUAL VCPKG_ROOT_DIR_CANDIDATE) # If unchanged, we have reached the root of the drive
        message(FATAL_ERROR "Could not find .vcpkg-root")
    else()
        SET(VCPKG_ROOT_DIR_CANDIDATE ${VCPKG_ROOT_DIR_TEMP})
    endif()
endwhile()

set(VCPKG_ROOT_DIR ${VCPKG_ROOT_DIR_CANDIDATE})

list(APPEND CMAKE_MODULE_PATH ${VCPKG_ROOT_DIR}/scripts/cmake)
set(CURRENT_INSTALLED_DIR ${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET} CACHE PATH "Location to install final packages")
set(DOWNLOADS ${VCPKG_ROOT_DIR}/downloads CACHE PATH "Location to download sources and tools")
set(PACKAGES_DIR ${VCPKG_ROOT_DIR}/packages CACHE PATH "Location to store package images")
set(BUILDTREES_DIR ${VCPKG_ROOT_DIR}/buildtrees CACHE PATH "Location to perform actual extract+config+build")

if(PORT)
    set(CURRENT_BUILDTREES_DIR ${BUILDTREES_DIR}/${PORT})
    set(CURRENT_PACKAGES_DIR ${PACKAGES_DIR}/${PORT}_${TARGET_TRIPLET})
endif()


if(CMD MATCHES "^BUILD$")
    string(REGEX REPLACE "([^-]*)-([^-]*)" "\\1" TRIPLET_SYSTEM_ARCH ${TARGET_TRIPLET})

    set(CMAKE_TRIPLET_FILE ${VCPKG_ROOT_DIR}/triplets/${TARGET_TRIPLET}.cmake)
    if(NOT EXISTS ${CMAKE_TRIPLET_FILE})
        message(FATAL_ERROR "Unsupported target triplet. Triplet file does not exist: ${CMAKE_TRIPLET_FILE}")
    endif()

	if(NOT DEFINED CURRENT_PORT_DIR)
        message(FATAL_ERROR "CURRENT_PORT_DIR was not defined")
    endif()
    set(TO_CMAKE_PATH "${CURRENT_PORT_DIR}" CURRENT_PORT_DIR)
    if(NOT EXISTS ${CURRENT_PORT_DIR})
        message(FATAL_ERROR "Cannot find port: ${PORT}\n  Directory does not exist: ${CURRENT_PORT_DIR}")
    endif()
    if(NOT EXISTS ${CURRENT_PORT_DIR}/portfile.cmake)
        message(FATAL_ERROR "Port is missing portfile: ${CURRENT_PORT_DIR}/portfile.cmake")
    endif()
    if(NOT EXISTS ${CURRENT_PORT_DIR}/CONTROL)
        message(FATAL_ERROR "Port is missing control file: ${CURRENT_PORT_DIR}/CONTROL")
    endif()

    message(STATUS "CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}")
    message(STATUS "DOWNLOADS=${DOWNLOADS}")

    message(STATUS "CURRENT_PACKAGES_DIR=${CURRENT_PACKAGES_DIR}")
    message(STATUS "CURRENT_BUILDTREES_DIR=${CURRENT_BUILDTREES_DIR}")
    message(STATUS "CURRENT_PORT_DIR=${CURRENT_PORT_DIR}")

    unset(PACKAGES_DIR)
    unset(BUILDTREES_DIR)

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR})
    if(EXISTS ${CURRENT_PACKAGES_DIR})
        message(FATAL_ERROR "Unable to remove directory: ${CURRENT_PACKAGES_DIR}\n  Files are likely in use.")
    endif()
    file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR} ${CURRENT_PACKAGES_DIR})

    include(${CMAKE_TRIPLET_FILE})
    include(${CURRENT_PORT_DIR}/portfile.cmake)

    set(BUILD_INFO_FILE_PATH ${CURRENT_PACKAGES_DIR}/BUILD_INFO)
    file(WRITE  ${BUILD_INFO_FILE_PATH} "CRTLinkage: ${VCPKG_CRT_LINKAGE}\n")
    file(APPEND ${BUILD_INFO_FILE_PATH} "LibraryLinkage: ${VCPKG_LIBRARY_LINKAGE}\n")

    if (DEFINED VCPKG_POLICY_DLLS_WITHOUT_LIBS)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyDLLsWithoutLIBs: ${VCPKG_POLICY_DLLS_WITHOUT_LIBS}\n")
    endif()
    if (DEFINED VCPKG_POLICY_EMPTY_PACKAGE)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyEmptyPackage: ${VCPKG_POLICY_EMPTY_PACKAGE}\n")
    endif()
    if (DEFINED VCPKG_POLICY_NO_DEBUG_BINARIES)
        file(APPEND ${BUILD_INFO_FILE_PATH} "PolicyNoDebugBinaries: ${VCPKG_POLICY_NO_DEBUG_BINARIES}\n")
    endif()
elseif(CMD MATCHES "^CREATE$")
    file(TO_NATIVE_PATH ${VCPKG_ROOT_DIR} NATIVE_VCPKG_ROOT_DIR)
    file(TO_NATIVE_PATH ${DOWNLOADS} NATIVE_DOWNLOADS)
    if(EXISTS ports/${PORT}/portfile.cmake)
        message(FATAL_ERROR "Portfile already exists: '${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\portfile.cmake'")
    endif()
    if(NOT FILENAME)
        get_filename_component(FILENAME "${URL}" NAME)
    endif()
    string(REGEX REPLACE "(\\.(zip|gz|tar|tgz|bz2))+\$" "" ROOT_NAME ${FILENAME})
    if(EXISTS ${DOWNLOADS}/${FILENAME})
        message(STATUS "Using pre-downloaded: ${NATIVE_DOWNLOADS}\\${FILENAME}")
        message(STATUS "If this is not desired, delete the file and ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}")
    else()
        include(vcpkg_download_distfile)
        file(DOWNLOAD ${URL} ${DOWNLOADS}/${FILENAME} STATUS error_code)
        if(NOT error_code MATCHES "0;")
            message(FATAL_ERROR "Error downloading file: ${error_code}")
        endif()
    endif()
    file(SHA512 ${DOWNLOADS}/${FILENAME} SHA512)

    file(MAKE_DIRECTORY ports/${PORT})
    configure_file(scripts/templates/portfile.in.cmake ports/${PORT}/portfile.cmake @ONLY)
    configure_file(scripts/templates/CONTROL.in ports/${PORT}/CONTROL @ONLY)

    message(STATUS "Generated portfile: ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\portfile.cmake")
    message(STATUS "Generated CONTROL: ${NATIVE_VCPKG_ROOT_DIR}\\ports\\${PORT}\\CONTROL")
    message(STATUS "To launch an editor for these new files, run")
    message(STATUS "    vcpkg edit ${PORT}")
endif()
