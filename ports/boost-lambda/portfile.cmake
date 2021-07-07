# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda
    REF boost-1.76.0
    SHA512 3cde15d39798398938a896b9bba624ff78ca3eb22ae04b3293f7f63fa5408bfac227ce191b0cee8753ca8f521e16b682b2d035125d75788815635586f122355a
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
