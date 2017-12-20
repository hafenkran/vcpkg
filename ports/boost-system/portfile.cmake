# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/system
    REF boost-1.66.0
    SHA512 97181610bc577182cb83c55b7c5d73aec6794543c0a7b43b4d08c7a1ed9936500f383038dbda1c0876f58d52c000f8b2e4a6bc1f68d14c7d9f015918f1c46851
    HEAD_REF master
)

boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
