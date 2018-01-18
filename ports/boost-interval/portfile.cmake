# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interval
    REF boost-1.66.0
    SHA512 adc8e7cf75de4f07607b2a13f38c4bb442780e7ad2e5a73f831803101f61f3d93d8d26407d68b1f811309e9a1362613fd29b5ff49e013341d421b0e76d6f4a69
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
