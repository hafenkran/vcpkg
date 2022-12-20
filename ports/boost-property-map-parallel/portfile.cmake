# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map_parallel
    REF boost-1.81.0
    SHA512 0baee8c8aa1b014ae921c95edef76a7b4e9bdf1f5d492164240190b60807750e54fa223c4a0a0493bdd1a111e4684ccc48be61393d7f4c10144b22540303a74f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
