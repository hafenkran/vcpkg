# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/array
    REF boost-1.69.0
    SHA512 7d9eaea992faf31af6c0cf793d543e53dee6a5d827c232e3cc86b639cd4e5dc0d3b6daec46144fc1953083aa7d60e87d6292fa518be1d1b499bc58804c28a443
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
