# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_array
    REF boost-1.67.0
    SHA512 a1f58b1223ffc6935d3ff9dd599dea294af36e9532adef471be0c971450ffd5ebafed6b0ab61637663df22e933b066eccac1fa50c783961d7a4bcf209c7d0fbb
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
