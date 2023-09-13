# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/dll
    REF boost-1.83.0
    SHA512 1a45b45673301809a6ad4f4aadfcebf7566f9ed973e35982b3cf4b39a881e2573517a5ad40af749714474fb13e69087b1a7f3dc1a81df0093a1e60fec022011c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
