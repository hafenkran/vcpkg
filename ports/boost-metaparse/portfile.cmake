# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/metaparse
    REF boost-1.71.0
    SHA512 3a3d2dc57151c57426c4a4f7bd4543714dc44e1792f2400ff5629938d187a64ec4a86d1133f2773c19000eddbbcaa52f06e0d3ea5cfa8cf0fb5adf8a6ada47ca
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
