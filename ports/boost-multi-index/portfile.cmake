# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_index
    REF boost-1.70.0
    SHA512 2068a3f7b493dcb5d3658e6c5d0134bd8009c90bea590fa97cc78d5b86386cfa42bb98a30b06c85270c2440ccc9aa092ec78fb9227bc9c90ad4e2d7480773e32
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
