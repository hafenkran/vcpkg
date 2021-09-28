# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/parameter
    REF boost-1.77.0
    SHA512 a9a46096b62af9a938403fe007cdf6ea7a0a5f1bd47bbecaad0e947c8175f848ccc44028a10470af3815157a604f4c2156ddc59d1dda07a1a0c1213728062932
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
