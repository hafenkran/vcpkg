# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/graph_parallel
    REF boost-1.81.0
    SHA512 31de00adb53686cc6518a0392a9987f74d55deb8fa1649a994fd12871be12f6d1729021052453f1a9b6a92daa54149572c79acfc06394df0be9f1b752412da24
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
