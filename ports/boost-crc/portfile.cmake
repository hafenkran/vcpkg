# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/crc
    REF boost-1.72.0
    SHA512 f6fb2e5f14255e60f649389c5e9602d703a0a597499408b749a83e8c6740d1a49475583476c38f7f7810df1b332c31e4e07ce340d2519189b0f47e70792b0896
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
