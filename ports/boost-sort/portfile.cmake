# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/sort
    REF boost-1.73.0
    SHA512 7a771fc0f49815b7df4213a92ed2a0ca6897523ebe28a5d00608949c94839ce167e9c8220f227b3dbbd04f300d915cc53a1501fcfb0f7ca9c7dc7fd2f3b26b1e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
