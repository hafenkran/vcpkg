# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interval
    REF boost-1.68.0
    SHA512 68596d0516e21132d9ea490ad7cdc66ed17e58f27a4f2a602481ba5e1b38fa51d6d4300108c2eaa1c457493212ee36ecd6f1d2a4b6ca3d1a4fbee23ad0216b38
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
