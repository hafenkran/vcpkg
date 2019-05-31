INCLUDE(vcpkg_common_functions)

IF (NOT VCPKG_CMAKE_SYSTEM_NAME)
    SET(EXEC_ENV "Windows")
ELSE ()
    SET(EXEC_ENV "${VCPKG_CMAKE_SYSTEM_NAME}")
ENDIF ()

IF (NOT EXEC_ENV STREQUAL "Linux")
    MESSAGE(FATAL_ERROR "Intel(R) Intelligent Storage Acceleration Library currently only supports Linux platforms")
    MESSAGE(STATUS "Well, it is not true, but I didnt manage to get it working on Windows")
ENDIF ()

IF (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    MESSAGE(FATAL_ERROR "Intel(R) Intelligent Storage Acceleration Library currently only supports x64 architecture")
ELSEIF (NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    MESSAGE(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
ENDIF ()

VCPKG_FROM_GITHUB(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO spdk/isa-l
        REF spdk
        SHA512 1d170ed050fb612816c77b3586f1cdce9129eedc559e3fcefc983ede05b6c8e13a52e400ee6935f5da6ab045a899c97f6ed6be3a79691284e211ea8a6d697f7c
        HEAD_REF master
)

VCPKG_FIND_ACQUIRE_PROGRAM(NASM)
GET_FILENAME_COMPONENT(NASM_PATH ${NASM} DIRECTORY)
SET(ENV{PATH} "$ENV{PATH};${NASM_PATH}")

VCPKG_FIND_ACQUIRE_PROGRAM(YASM)

VCPKG_CONFIGURE_CMAKE(
        SOURCE_PATH ${CMAKE_CURRENT_LIST_DIR}
        PREFER_NINJA
        OPTIONS
        -DSOURCE_PATH=${SOURCE_PATH}
        -DEXEC_ENV:STRING=${EXEC_ENV}
        -DLIBRARY_LINKAGE:STRING=${VCPKG_LIBRARY_LINKAGE}
)

VCPKG_INSTALL_CMAKE()

FILE(INSTALL ${SOURCE_PATH}/Release/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib/spdk)
FILE(INSTALL ${SOURCE_PATH}/Debug/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/spdk)
FILE(INSTALL ${SOURCE_PATH}/Release/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/spdk-isalConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

VCPKG_TEST_CMAKE(PACKAGE_NAME ${PORT})
