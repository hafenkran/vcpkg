# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/format
    REF boost-1.67.0
    SHA512 31d355d0986f18f32373a45ee6a5d4d8f688dcc3bd13fdf388dd77166459871deb33bc7ecc9dbbc46fcf546ba3ed8a475c5f4fdcf6377af320ec18d15a9a35d4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
