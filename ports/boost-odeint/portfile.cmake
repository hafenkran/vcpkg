# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.66.0
    SHA512 f4d1a0d689c64bbd3dc93060e0e787aa39940b4ca0baf557ea7cb1c28225af5388d24b1654be04103427ba3b943f83dc34be1c0acedcdc2a9b8ac63acbe6946c
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
