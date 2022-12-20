# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/unordered
    REF boost-1.81.0
    SHA512 beb1227428cac6d4714fd51aa660830d07816f5cbf102e43145ce8920f3470195a0138e5a8b1ddf8f7d304f6ea59bb8b7110afed9b9e80485c8a9bfb2cd5e6c2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
