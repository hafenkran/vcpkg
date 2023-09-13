# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/process
    REF boost-1.83.0
    SHA512 854e101dd1879f6a4a9033201a59297acef5beb0dbb2228b099b94ae4e5755b65a5052df45a9748b7c58f4c515cfc03ec2d80284c1a77baea78611c80c87e7cc
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
