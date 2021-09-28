# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/hof
    REF boost-1.77.0
    SHA512 8cbcc9ff6bf092c5ac90a44304a7e5eb2e969ad5d14d6913549941e941fe8bf1d2cabadfd6b4808fa494306eb53e9d1a5e6a9c7efa28db15b9844e87713e3cd6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
