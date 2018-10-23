# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/dynamic_bitset
    REF boost-1.68.0
    SHA512 7fa486d3088966fedcc30cced1282b997da39134dc1dcae3382a532c5b64a1965b761f8fd130ca7901aabd77375a84c66597c509c612ba1f99c238c0a754974c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
