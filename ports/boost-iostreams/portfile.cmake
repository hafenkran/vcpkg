# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/iostreams
    REF boost-1.72.0
    SHA512 a1a57e7cd985f5962a96fc93d286a64065611dea1a17fdfe696455556f176b9429e4aaf2a5035808a40d0fb7e8dfb874ac6f2ddc33ecc44c25a8089034960403
    HEAD_REF master
    PATCHES Removeseekpos.patch
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
