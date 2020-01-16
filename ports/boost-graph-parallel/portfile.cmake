# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/graph_parallel
    REF boost-1.72.0
    SHA512 8ef6e2df93a6df52f03cde0ea42cb028c97c4f0be668b8baaf7f3447eef577f8272824afd9c990c61338bc2816824cb01fc7568906f1f621a0b2bb4bfcb48d26
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
