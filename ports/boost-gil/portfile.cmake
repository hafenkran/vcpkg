# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/gil
    REF boost-1.73.0
    SHA512 d7466e3d7b3dfad9545fbb659a4a8e4d95b42f06dcdfa2cc12f3839de04b003ae7ce27abc4089ec90870a8e2b2d7d350ea4c02da3d18eda111fc4abb32165ff3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
