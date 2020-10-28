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
        REPO 01org/isa-l
        REF v2.25.0
        SHA512 aa556c8ba26b4637493b3de50a23636668bcfd71249029c52fe6983d0bcf120d1b91f39aaa259cb58e59448d401366f3bfaaee24609db7e6a1cd3fdf1a953efe
        HEAD_REF master
)

VCPKG_FIND_ACQUIRE_PROGRAM(NASM)
GET_FILENAME_COMPONENT(NASM_PATH ${NASM} DIRECTORY)
SET(ENV{PATH} "$ENV{PATH};${NASM_PATH}")

VCPKG_CONFIGURE_CMAKE(
        SOURCE_PATH ${CMAKE_CURRENT_LIST_DIR}
        PREFER_NINJA
        OPTIONS
        -DSOURCE_PATH=${SOURCE_PATH}
        -DEXEC_ENV:STRING=${EXEC_ENV}
        -DLIBRARY_LINKAGE:STRING=${VCPKG_LIBRARY_LINKAGE}
)

VCPKG_INSTALL_CMAKE()

FILE(INSTALL ${SOURCE_PATH}/Release/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
FILE(INSTALL ${SOURCE_PATH}/Debug/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
FILE(INSTALL ${SOURCE_PATH}/Release/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/isalConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
