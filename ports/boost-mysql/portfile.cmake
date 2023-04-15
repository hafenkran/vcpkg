# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mysql
    REF boost-1.82.0
    SHA512 e83a7ab69ee28e5eb19ee2e5a19141979f83342cca8402673829f60eb9d8c969dc41542e357b9ffac3da5917d6c5e2d7b4131044eccfba5b01b2b63c97f05edf
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
