# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/detail
    REF boost-1.70.0
    SHA512 8cedb220dce3a4f6aaee13eacdd5c8246e707b724bd260d025b7ece9336dffaa645a3cf59f90ea02136a23126e9a93116485ad5d76e8b04d46e08f043c394018
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
