# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/timer
    REF boost-1.81.0
    SHA512 75c1aa0b3faac45d01eee58456b0cf620bbf9dc1e0481f109554fc590c7a5f35832f1ee5e6665c85c48672b3282b59ce3fc3b75a432078e9f6061345b43af0f2
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
