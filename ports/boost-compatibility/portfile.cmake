# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compatibility
    REF boost-1.81.0
    SHA512 8931256236336c07c029d39a1599ef524444b0870140fcabdcee3c3106c7ecf92cf32a2bfb442244bbc8078c783ca552a74fe5243c1644fb3e210e9f5f2836f1
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
