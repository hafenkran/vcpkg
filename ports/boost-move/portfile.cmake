# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/move
    REF boost-1.76.0
    SHA512 f136696c88f398d27e97f77141f10c1ab80b0bccf9acdecc3c0e886c8f32e8e9bc9fe51ba563c814e20d71a15c01f70d96ffd88d5a6c5e297f568959492bc982
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
