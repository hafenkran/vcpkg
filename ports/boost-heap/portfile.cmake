# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/heap
    REF boost-1.83.0
    SHA512 372bb5b2c92792f0d60a045271eab60eaf1d8743e72afea7686fe24c478aceffc598689e8a65479812c93517701671d5c4505dddf770c73eec1127a6a6318cb2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
