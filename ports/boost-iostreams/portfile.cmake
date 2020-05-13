# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/iostreams
    REF boost-1.73.0
    SHA512 0bfafdf0bd202a958b353c2b575957061427cd0e6c66ab7e826c2a7958ed57d89dc8a49b0e01e63689703404f335f964f390241fdc1982f374f10c4583fd89a2
    HEAD_REF master
    PATCHES Removeseekpos.patch
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
