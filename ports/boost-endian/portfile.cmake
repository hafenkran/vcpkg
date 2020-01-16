# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/endian
    REF boost-1.72.0
    SHA512 bdcec1badfe7583143dc405c3eb2a3f55d5d2cc742f54265e8d6d5b156ef09523379fc49cf39eefacf22fa276c20b742b389b6dae3530fc377b5b8dc3686cf75
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
