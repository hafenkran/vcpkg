# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/signals2
    REF boost-1.83.0
    SHA512 6a9186d956c41527add674d81a345a9f55416ddd5b9c35123ca0e5e38e55e40a5ad4c7f5c999b11781696d2255761b6c46ab6c1790bc62a1966dba4bb5b3ddf5
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
