# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/assert
    REF boost-1.68.0
    SHA512 fd5ffc755f9f0926adeb1d0f3ceea448094e5dcd94c3c9eaa203676bb790729c8e02e66633535f7eaa1df186d88eeb983ed894c181666489a6a3bf9323a8eac0
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
