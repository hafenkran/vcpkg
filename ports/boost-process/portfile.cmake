# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/process
    REF boost-1.77.0
    SHA512 00eb27f702f092a20fdf1669b8c9c993b751971592d0bc5aa50b02d99d985a75361621b624aa51eb550c9e7905e15877168ae9d0feb1957fc85f99c264b152fd
    HEAD_REF master
    PATCHES
        fix_include.patch
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
