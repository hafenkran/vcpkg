# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/graph_parallel
    REF boost-1.82.0
    SHA512 b64c1f4dd1f647e5ca94d5463f20fad35f00e4030cd63f7516b0fbdda69ba8d81ec93234f9812dabdea9219bb1f438a550542d020ceb583ba801257d7d0100d9
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
