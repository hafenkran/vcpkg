IF (VCPKG_TARGET_IS_WINDOWS)
    SET(EXEC_ENV "Windows")
ELSE ()
    SET(EXEC_ENV "${VCPKG_CMAKE_SYSTEM_NAME}")
ENDIF ()

IF (NOT EXEC_ENV STREQUAL "Linux")
    MESSAGE(FATAL_ERROR "Intel(R) Multi-Buffer Crypto for IPsec Library currently only supports Linux/Windows platforms")
    MESSAGE(STATUS "Well, it is not true, but I didnt manage to get it working on Windows")
ENDIF ()

IF (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    MESSAGE(FATAL_ERROR "Intel(R) Multi-Buffer Crypto for IPsec Library currently only supports x64 architecture")
ELSEIF (NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    MESSAGE(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
ENDIF ()

VCPKG_FROM_GITHUB(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO intel/intel-ipsec-mb
        REF v0.52
        SHA512 3b115fb6df53801800a63a3b62198165824a9262d579a7696f1ec365a5680282b172ffac742fe6453ae53b97043c19136adf558a85a0e51d163b27be2abc9e63
        HEAD_REF master
)

VCPKG_FIND_ACQUIRE_PROGRAM(NASM)

EXEC_PROGRAM(${NASM}
             ARGS -v
             OUTPUT_VARIABLE NASM_OUTPUT
             )
STRING(REGEX REPLACE "NASM version ([0-9]+\\.[0-9]+\\.[0-9]+).*" "\\1"
       NASM_VERSION
       ${NASM_OUTPUT})
IF (NASM_VERSION VERSION_LESS 2.13.03)
    MESSAGE(FATAL_ERROR "NASM version 2.13.03 (or newer) is required to build this package")
ENDIF ()

GET_FILENAME_COMPONENT(NASM_PATH ${NASM} DIRECTORY)
SET(ENV{PATH} " $ENV{PATH};${NASM_PATH} ")

VCPKG_CONFIGURE_CMAKE(
        SOURCE_PATH ${CMAKE_CURRENT_LIST_DIR}
        PREFER_NINJA
        OPTIONS
        -DSOURCE_PATH=${SOURCE_PATH}
        -DEXEC_ENV=${VCPKG_CMAKE_SYSTEM_NAME}
        -DLIBRARY_LINKAGE=${VCPKG_LIBRARY_LINKAGE}
)

VCPKG_INSTALL_CMAKE()

FILE(INSTALL ${SOURCE_PATH}/Release/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
FILE(INSTALL ${SOURCE_PATH}/Debug/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
FILE(INSTALL ${SOURCE_PATH}/Release/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/intel-ipsecConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

#VCPKG_TEST_CMAKE(PACKAGE_NAME ${PORT})
