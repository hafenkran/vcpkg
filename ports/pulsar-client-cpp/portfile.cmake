vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/pulsar-client-cpp
    REF "v${VERSION}"
    SHA512 b1f56ca8d5edb7faaba68eb4e04fcb4e458ccf2c7a5b0fb6d66868c6507081344fb3f0ebb29afe9aef567295a249b09cdeb3fb00285746767bbccef65a0f6e70
    HEAD_REF main
    PATCHES
      0001-use-find-package.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" BUILD_STATIC_LIB)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_DYNAMIC_LIB)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
        -DBUILD_PERF_TOOLS=OFF
        -DBUILD_DYNAMIC_LIB=${BUILD_DYNAMIC_LIB}
        -DBUILD_STATIC_LIB=${BUILD_STATIC_LIB}
)

vcpkg_cmake_install()

if (BUILD_STATIC_LIB)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/pulsar/defines.h"
        "#ifdef PULSAR_STATIC"
        "#if 1")
endif ()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)

configure_file("${CMAKE_CURRENT_LIST_DIR}/unofficial-pulsar-config.cmake" "${CURRENT_PACKAGES_DIR}/share/unofficial-pulsar/unofficial-pulsar-config.cmake" @ONLY)

vcpkg_copy_pdbs()
