INCLUDE(vcpkg_common_functions)

IF (NOT VCPKG_CMAKE_SYSTEM_NAME OR NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
    MESSAGE(FATAL_ERROR "Intel dpdk currently only supports Linux/BSD platforms")
ENDIF ()

VCPKG_FROM_GITHUB(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO DPDK/dpdk
        REF v19.02
        SHA512 e0cc7081b163b4e264b65c1abb7e0f8aa29211539cecc5cf52986699b800eb4d4f2026377c3048c5c3bd2791e41f21645bb655797a3300740aa83633fb87626e
        HEAD_REF master
)

FIND_PATH(NUMA_INCLUDE_DIR NAME numa.h
          PATHS ENV NUMA_ROOT
          HINTS $ENV{HOME}/local/include /opt/local/include /usr/local/include /usr/include
          )
IF (NOT NUMA_INCLUDE_DIR)
    MESSAGE(FATAL_ERROR "Numa library not found.\nTry: 'sudo yum install numactl numactl-devel' (or sudo apt-get install libnuma1 libnuma-dev)")
ENDIF ()

VCPKG_CONFIGURE_CMAKE(
        SOURCE_PATH ${CMAKE_CURRENT_LIST_DIR}
        PREFER_NINJA
        OPTIONS
        -DSOURCE_PATH=${SOURCE_PATH}
)

VCPKG_INSTALL_CMAKE()

# Headers are symbolic links here, gather all, resolve and copy real files
FILE(GLOB_RECURSE HEADERS FOLLOW_SYMLINKS "${SOURCE_PATH}/build/include/*")
SET(REAL_FILES "")
FOREACH (HEADER ${HEADERS})
    GET_FILENAME_COMPONENT(REAL_FILE "${HEADER}" REALPATH)
    LIST(APPEND REAL_FILES "${REAL_FILE}")
ENDFOREACH ()

FILE(INSTALL ${SOURCE_PATH}/Release/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
FILE(INSTALL ${SOURCE_PATH}/Debug/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
FILE(INSTALL ${REAL_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/dpdkConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
FILE(INSTALL ${SOURCE_PATH}/license/README DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

VCPKG_TEST_CMAKE(PACKAGE_NAME ${PORT})
