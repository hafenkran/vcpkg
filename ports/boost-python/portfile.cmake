# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/python
    REF boost-1.83.0
    SHA512 ef0b597b8be2550d4fb89eced8cd678f170dba315ef78becc319ef848d69772a6da3b2439cfc799b1663fad15b8ba8e679f0781b43abe2f3685fa1091b60f927
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
