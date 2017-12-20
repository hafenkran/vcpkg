# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compute
    REF boost-1.66.0
    SHA512 c540200a62faf4e4b5895177d9b33f9316d0d5e4052f3bfea7eb33d9faa9446bd5015c55f59c923134c59d635f1078e1e7e50e013636efc65820056bb6bdb704
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
