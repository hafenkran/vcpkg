# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mpi
    REF boost-1.75.0
    SHA512 0fc0721564c431a959bfe5d5c8c5b8b3c1d2eba32f14a3158746386806be0eaee8abedadce1b4bbb9a82a63764ff351d5b1e3c2be224ea49cd55ef4ebfa9ae5f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
