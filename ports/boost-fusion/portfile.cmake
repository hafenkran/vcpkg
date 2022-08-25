# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/fusion
    REF boost-1.80.0
    SHA512 77121dc0bf188b530d2d7e2ab6ab5c6d3e8c01f9a063e581187bd3cce5ab35002c08f47dc5bce03487344b50c1fc1817f9cf4e1daeece9ce96ae5a2a99ac632e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
