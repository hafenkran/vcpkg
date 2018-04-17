# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/sort
    REF boost-1.67.0
    SHA512 dfd8f61aa342c226a88390f8b05d394fd8c019ebc8d008dbb3022bca4716d4e9623e9d2024fd3143ead3de89441b470dc234252b96d80dcd3d6e2be5ce4bd090
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
